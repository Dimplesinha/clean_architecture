import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/style/style.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03/09/24
/// @Message : [VerifiedScreen]

///The `VerifiedScreen` class is verified screen which is called after email verification screen.
///Typically, it shows verified icon and done button on it.
///
/// Responsibilities:
/// - This screen will be displayed after email verification screen.
/// - It indicates if email is verified or not.
class VerifiedScreen extends StatefulWidget {
  final String token;
  final bool isFromSignUp;
  const VerifiedScreen({super.key,required this.token,this.isFromSignUp = false});

  @override
  State<VerifiedScreen> createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {

  ///SingleChildScrollView to control scroll and LayoutBuilder which is used with constraint for mobile view and
  ///tablet view.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(

          appBar: MyAppBar(
            title: AppConstants.verifiedStr,
            centerTitle: true,
            backBtn: false,
            automaticallyImplyLeading: false,
            shadowColor: AppColors.borderColor,
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: LayoutBuilder(builder: (context, constraints) {
              return _mobileView();
            }),
          ),
        ),
      ),
    );
  }

  ///Mobile view with all the widgets to display with text and icon.
  Widget _mobileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sizedBox50Height(),
        _circleVerifiedIcon(),
        sizedBox40Height(),
        _subTitleText(),
        sizedBox40Height(),
        _doneBtn(),
      ],
    );
  }

  ///Verified Icon with circle to display on top of verified success msg.
  Widget _circleVerifiedIcon() {
    return CircleAvatar(
      radius: 80.0,
      backgroundColor: AppColors.circleColor,
      child: SvgPicture.asset(AssetPath.verifiedIcon),
    );
  }

  ///This will display success msg of verified
  Widget _subTitleText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        AppConstants.verifiedSubStr,
        style: FontTypography.subString,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Done button when clicking on it will redirect you to home screen
  Widget _doneBtn() {
    return AppButton(
      function: () {
        if(widget.isFromSignUp){
          AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
        } else {
          AppRouter.pushReplacement(AppRoutes.newPasswordScreenRoute,args: {
            ModelKeys.token : widget.token
          });
        }
      },
      title: AppConstants.doneStr,
    );
  }
}
