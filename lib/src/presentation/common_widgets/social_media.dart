/*
import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
// import 'package:social_media_package/social_media_package.dart';

class SocialMediaView extends StatelessWidget {
  final bool isFromLogin;
  final Function onGoogleTap;
  final Function onFbTap;
  final Function onTwitterTap;

  const SocialMediaView({
    Key? key,
    this.isFromLogin = false,
    required this.onGoogleTap,
    required this.onFbTap,
    required this.onTwitterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _mainColumnView(context),
        _bottomBtnAlreadyMember(),
      ],
    );
  }

  Widget _googleLoginBtn(BuildContext context) {
    return SocialMediaButton(
      onTap: onGoogleTap,
      buttonType: ButtonType.google,
      backgroundColor: AppColors.socialBtnColor,
      iconColor: Colors.black,
    );
  }

  Widget _fbLoginBtn(BuildContext context) {
    return SocialMediaButton(
      onTap: onFbTap,
      buttonType: ButtonType.facebook,
      backgroundColor: AppColors.socialBtnColor,
      iconColor: Colors.black,
    );
  }

  Widget _twitterLoginBtn(BuildContext context) {
    return SocialMediaButton(
      onTap: onTwitterTap,
      buttonType: ButtonType.twitter,
      backgroundColor: AppColors.socialBtnColor,
      iconColor: Colors.black,
    );
  }

  Widget _bottomBtnAlreadyMember() {
    return Column(
      children: [
        const SizedBox(width: 20, height: 50),
        InkWell(
          onTap: () {
            if (isFromLogin) {
              // AppRoutes.push(AppRoutes.signUp);
            } else {
              navigatorKey.currentState?.pop();
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isFromLogin ? AppConstants.notAMemberStr : AppConstants.alreadyMemberStr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppConstants.fontFamilyProductSans,
                ),
              ),
              const SizedBox(width: 5, height: 5),
              Text(
                isFromLogin ? AppConstants.signUpStr : AppConstants.signInStr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                  fontFamily: AppConstants.fontFamilyProductSans,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20, height: 50)
      ],
    );
  }

  Widget _mainColumnView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(width: 20, height: 20),
        const Row(
          children: [
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Or',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppConstants.fontFamilyProductSans,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        const SizedBox(width: 20, height: 20),
        _socialBtn(context),
      ],
    );
  }

  Widget _socialBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _fbLoginBtn(context),
        const SizedBox(width: 10, height: 5),
        _twitterLoginBtn(context),
        const SizedBox(width: 10, height: 5),
        _googleLoginBtn(context),
      ],
    );
  }
}
*/
