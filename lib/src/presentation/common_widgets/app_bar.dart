import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

///MyAppBar with same design throughout the app
///few parameters are centralized which are used for modification on different screen
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? titleSpacing;
  final List<Widget>? actionList;
  final VoidCallback? backBtnCallback;
  final bool? automaticallyImplyLeading;
  final bool? backBtn;
  final double? elevation;
  final bool? isProfilePicVisible;
  final Widget? widget;
  final bool? centerTitle;
  final Color? shadowColor;
  final Color? backGroundColor;
  final TextStyle? appBarTitleTextStyle;
  final Function(bool)? rightIconCallback;
  final bool? isVisibleDeleteText;
  final bool? isCancel;
  final bool? requirePop;

  const MyAppBar({
    Key? key,
    required this.title,
    this.titleSpacing,
    this.actionList,
    this.backBtnCallback,
    this.automaticallyImplyLeading,
    this.backBtn = true,
    this.centerTitle = true,
    this.elevation,
    this.widget,
    this.isProfilePicVisible,
    this.shadowColor,
    this.backGroundColor,
    this.appBarTitleTextStyle,
    this.rightIconCallback,
    this.isVisibleDeleteText = false,
    this.isCancel = false,
    this.requirePop = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backBtnCallback?.call();
        //Pass data back to the first page
        if (requirePop == true) {
          // Handle the back button press here
          Navigator.of(context).pop('Data from Second Page');
        }
        return false;
      },
      child: AppBar(
        titleSpacing: titleSpacing ?? 0.0,
        automaticallyImplyLeading: automaticallyImplyLeading ?? true,
        centerTitle: centerTitle ?? true,
        leading: centerTitle == true
            ? Visibility(
                visible: backBtn == true,
                child: IconButton(
                  onPressed: () {
                    backBtnCallback?.call();
                    //Pass data back to the first page
                    if (requirePop == true) {
                      Navigator.of(context).pop('Data from Second Page');
                    }
                  },
                  icon: Icon(Icons.arrow_back_ios, size: 20, color: appBarTitleTextStyle?.color ?? Colors.black),
                ),
              )
            : null,
        title: centerTitle == true
            ? Text(
                title,
                maxLines: 2,
                style: appBarTitleTextStyle ?? FontTypography.appBarStyle,
              )
            : Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Visibility(
                      visible: backBtn == true,
                      child: IconButton(
                        onPressed: () {
                          backBtnCallback?.call();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: appBarTitleTextStyle ?? FontTypography.appBarStyle,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isVisibleDeleteText!,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: GestureDetector(
                          child: Text(
                            isCancel! ? AppConstants.cancel2Str : AppConstants.deleteStr,
                            style: TextStyle(
                              color: isCancel == null || isCancel == false ? AppColors.deleteColor : AppColors.blackColor,
                            ),
                          ),
                          onTap: () {
                            rightIconCallback?.call(isCancel ?? false);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
        backgroundColor: backGroundColor ?? Colors.white,
        foregroundColor: backGroundColor ?? Colors.transparent,
        surfaceTintColor: backGroundColor ?? Colors.white,
        elevation: elevation ?? 3.0,
        actions: actionList,
        shadowColor: shadowColor,
        // leading: null,
      ),
    );
  }
}
