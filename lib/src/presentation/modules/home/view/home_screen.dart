import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/master_data/master_data_api.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/dynamic_add_listing/view/dynamic_add_listing_view.dart';
import 'package:workapp/src/presentation/modules/home/cubit/landing_page_cubit.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';
import 'package:workapp/src/presentation/modules/message/view/message_list_tab_view.dart';
import 'package:workapp/src/presentation/modules/modules.dart';
import 'package:workapp/src/presentation/modules/my_listing/view/my_listing.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/utils/date_time_utils.dart';
import 'package:workapp/src/utils/signalr_helper.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04/09/24
/// @Message : [LandingPage]
class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  /// Scaffold Key to open drawer from a custom button
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LandingPageCubit landingPageCubit = LandingPageCubit();
  final pageController = PageController();
  int _bottomNavIndex = 0;
  bool check = false;
  bool isPasswordAvailable = false;
  String firstName = '';
  String lastName = '';
  String profilePic = '';
  List<Widget> pages = [];
  final SignalRHelper signalRHelper = SignalRHelper.instance;
  final MessageCubit messageCubit =MessageCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      landingPageCubit.init();
      categoryAPICall();
    });

    pages.addAll([
      (Dashboard(drawerIconEnableCallback: (isEnable) {
        landingPageCubit.enableDrawerIcon(isEnable);
      })),
      (const MyListing()),
      (const DynamicAddListingView()),
      (const MessageListing()),

      /// Image picker example and image preview added on this page
    ]);
    super.initState();

    messageCubit.updateChatUnreadCount = () {
      landingPageCubit.getChatUnreadCount();
    };

    signalRHelper.onMessageReceivedInHomeScreen = (message) async {
      await landingPageCubit.getChatUnreadCount();
      landingPageCubit.updateUnreadMessageCount();
    };


    signalRHelper.sendConnectionId = (value) {
      landingPageCubit.sendConnectionId(value);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<LandingPageCubit, LandingPageState>(
        bloc: landingPageCubit,
        builder: (context, state) {
          firstName = state.loginModel?.result?.firstName ?? '';
          lastName = state.loginModel?.result?.lastName ?? '';
          profilePic = state.loginModel?.result?.profilepic ?? '';

          isPasswordAvailable = state.loginModel?.result?.isPasswordAvailable ?? false;
          return Stack(
            children: [
              Scaffold(
                key: _scaffoldKey,
                appBar: _bottomNavIndex == 0
                    ? AppBar(
                        backgroundColor: AppColors.primaryColor,
                        centerTitle: true,
                        title: ReusableWidgets.createSvg(path: AssetPath.workAppLogo, size: 30),
                        leading: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            bottom: 8,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (state.isLogin) {
                                if (state.isEnableDrawer) _scaffoldKey.currentState?.openDrawer();
                              } else {
                                AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.homeCategoryIconBgColor,
                              child: ReusableWidgets.createSvg(path: AssetPath.categoryLogo),
                            ),
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                              icon: ReusableWidgets.createSvg(
                                  path: AssetPath.searchIconSvg, // Add the path to your custom SVG search icon
                                  size: 22, // Adjust the size if needed
                                  color: AppColors.whiteColor),
                              onPressed: () async {
                                var categoryData = await PreferenceHelper.instance.getCategoryList();
                                var categoriesList = categoryData.result;
                                AppRouter.push(AppRoutes.searchScreenRoute,
                                    args: {ModelKeys.categoriesList: categoriesList});
                              },
                              /*onPressed: () async {
                                var categoryData = await PreferenceHelper.instance.getCategoryList();
                                var categoriesList = categoryData.result;
                                AppRouter.push(AppRoutes.advanceSearchScreenRoute,
                                    args: {ModelKeys.categoriesList: categoriesList});
                              },*/
                            ),
                          )
                        ],
                      )
                    : null,
                drawerEnableOpenDragGesture: state.isLogin && state.isEnableDrawer,
                drawer: MyDrawer(
                    firstName: firstName,
                    profilePic: profilePic,
                    isPasswordAvailable: isPasswordAvailable,
                    lastName: lastName),
                body: PageView(  controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),children: pages),
                bottomNavigationBar: MyBottomNavigationView(
                  index: bottomNavIndex,
                  unreadMessagesCount: state.unreadChatCount,
                  onTap: (int index) {
                    pageController.jumpToPage(index);
                    if (state.isLogin) {
                      setState(() => _bottomNavIndex = index);
                    } else {
                      AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
                    }
                  },
                ),
              ),
              state.loading ? const LoaderView() : const SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }

  void categoryAPICall() async {
    try {
      var categoryData = await PreferenceHelper.instance.getCategoryList();

      if (categoryData.result != null) {
        DateTime currentDate = DateTime.now();
        String currentFormattedDate = DateTimeUtils.instance.timeStampToDateOnly(currentDate);
        if (categoryData.getCategoryLoadedDate() != currentFormattedDate) {
          await MasterDataAPI.getCategoriesList();
        } else {
          await PreferenceHelper.instance.getCategoryList();
        }
      } else {
        await MasterDataAPI.getCategoriesList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('--$this---print-----   ${e.toString()}');
      }
    }
  }

  /// Body Widgets

  int get bottomNavIndex => _bottomNavIndex;

  set bottomNavIndex(int value) => setState(() => _bottomNavIndex = value);
}
