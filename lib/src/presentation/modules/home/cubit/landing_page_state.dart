part of 'landing_page_cubit.dart';

final class LandingPageState extends Equatable {
  final bool loading;
  final LoginResponse? loginModel;
  final int changeIndex;
  final bool isLogin;
  final bool isEnableDrawer;
  final int unreadChatCount;

  LandingPageState({
    this.loading = false,
    this.loginModel,
    this.changeIndex = 0,
    this.isLogin = false,
    this.isEnableDrawer = false,
    this.unreadChatCount = 0,
  });

  LandingPageState copyWith({
    LoginResponse? loginModel,
    bool? loading,
    int? changeIndex,
    bool? isLogin,
    bool? isEnableDrawer,
    int? unreadChatCount,
  }) {
    return LandingPageState(
      loginModel: loginModel ?? this.loginModel,
      loading: loading ?? this.loading,
      changeIndex: changeIndex ?? this.changeIndex,
      isLogin: isLogin ?? this.isLogin,
      isEnableDrawer: isEnableDrawer ?? this.isEnableDrawer,
      unreadChatCount: unreadChatCount ?? this.unreadChatCount,
    );
  }

  @override
  List<Object?> get props => [loading, loginModel, changeIndex, isLogin,isEnableDrawer, unreadChatCount];
}
