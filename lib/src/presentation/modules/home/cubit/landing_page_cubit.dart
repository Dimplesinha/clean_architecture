import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/model_keys.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/repo/profile_basic_details_repo.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/signalr_helper.dart';

part 'landing_page_state.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit() : super(LandingPageState());
  bool check = false;
  LoginResponse userData = LoginResponse();

  /// SignalR variables
  final SignalRHelper _signalR = SignalRHelper.instance;
  bool _isInitializing = false;
  int? globalUnreadMessageCount = 0;

  void init() async {
    check = await PreferenceHelper.instance.getPreference(key: PreferenceHelper.isLogin, type: bool);
    PreferenceHelper preferenceHelper = PreferenceHelper.instance;
    userData = await preferenceHelper.getUserData();
    emit(LandingPageState());
    isLoggedIn();
    getProfileBasicDetails();
    _initializeConnection();
    getChatUnreadCount();
  }

  Future<void> _initializeConnection() async {
    if (!state.isLogin) {
      return;
    }

    if (_signalR.isConnected) {
      sendConnectionId(_signalR.connectionId);
      return;
    }

    if (_signalR.isConnecting || _isInitializing) {
      print('Connection already in progress or established.');
      return;
    }

      _isInitializing = true;

    try {
      await _signalR.connect(AppUtils.loginUserModel?.uuid ?? '', (success, result, error) {
        if (success && result != null && error == null) {
          sendConnectionId(result);
        }

      },);
    } catch (e) {
      // _showErrorDialog('Connection Error', e.toString());
    } finally {
      // if (mounted) {
      //   setState(() => _isInitializing = false);
      // }
    }
  }

  void isLoggedIn() async {
    try {
      emit(state.copyWith(isLogin: check, loginModel: userData));
    } catch (e) {
      emit(LandingPageState());
    }
  }

  void changeIndex(int index) async {
    try {
      emit(state.copyWith(changeIndex: index));
    } catch (e) {
      emit(LandingPageState());
    }
  }

  void getProfileBasicDetails() async {
    // Get older token as we're not getting token in user profile API. Because same API is used in Admin panel
    var user = await PreferenceHelper.instance.getUserData();
    String token = user.result?.token ?? '';
    var response =
        await ProfileBasicDetailsRepo.instance.getProfileBasicDetails(userId: state.loginModel?.result?.uuid??'');
    try {
      userData.result = response.responseData;
      userData.result?.token = token;
      // Check if "Remember Me" is enabled and set password 
      var rememberMe = user.result?.rememberMeEnabled ?? false;
      var password = user.result?.password;
      userData.result?.rememberMeEnabled = rememberMe;
      userData.result?.password = password;
      await PreferenceHelper.instance.setUser(userData);
      
      emit(state.copyWith(loading: false, loginModel: userData));
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }

  void sendConnectionId(String? connectionId) async {
    if (!state.isLogin) {
      return;
    }
    var user = await PreferenceHelper.instance.getUserData();
    Map<String, dynamic> requestBody = {
      ModelKeys.userId: user.result?.id,
      ModelKeys.connectionId: connectionId,
    };

    var response =
    await ProfileBasicDetailsRepo.instance.sendConnectionId(requestBody);
    try {
      emit(state.copyWith(loading: false));
    } catch (ex) {
      if (kDebugMode) {
        print(this);
      }
    }
  }
  Future<int> getChatUnreadCount() async {
    if (!state.isLogin) {
      return 0;
    }

    try {
      var response = await ProfileBasicDetailsRepo.instance.getChatUnreadCount();
      globalUnreadMessageCount = response.responseData?.result?.unreadCount ?? 0;

      emit(state.copyWith(loading: false, unreadChatCount: globalUnreadMessageCount));

      // 🔥 Push API result into the stream too
      SignalRHelper.instance.updateUnreadMessageCount(globalUnreadMessageCount!);

      return globalUnreadMessageCount!;
    } catch (ex) {
      emit(state.copyWith(loading: false));
      if (kDebugMode) {
        print('Error in getChatUnreadCount: $ex');
      }
      return 0;
    }
  }




  Future<void> updateUnreadMessageCount() async {
    int count = await getChatUnreadCount(); //  Await the latest unread count from server
    globalUnreadMessageCount = count;

    emit(state.copyWith(
      loading: false,
      unreadChatCount: count,
    ));

    SignalRHelper.instance.updateUnreadMessageCount(count);
  }



  void enableDrawerIcon(bool? isEnable) {
    emit(state.copyWith(
      loading: false,
      loginModel: userData,
      isEnableDrawer: isEnable,
    ));
  }
}
