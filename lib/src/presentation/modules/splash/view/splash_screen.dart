import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/core/routes/app_router.dart';
import 'package:workapp/src/utils/app_utils.dart';

///
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03/09/24
/// @Message : [SplashScreen]
///

/// The `SplashScreenView` class is the entry point of the application.
/// This view is displayed to the user while the app is loading and initializing its data.
/// Typically, it shows the app's logo or branding, and it's the first impression of the app.
///
/// Responsibilities:
/// - Display a brief visual before the app is ready to use.
/// - Optionally, load essential data or perform initial setup tasks.
/// - Transition to the main screen once the initialization is complete.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppUtils.getDeviceID();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: GifView.asset(
          AssetPath.splashScreenAnimation,
          height: screenHeight,
          width: screenWidth,
          frameRate: 25,
          loop: false,
          onFinish: (){
            AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute,);
          },
        ),
      ),
    );
  }
}
