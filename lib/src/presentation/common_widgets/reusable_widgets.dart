import 'dart:io';

import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/utils/network_utils.dart';

///
/// @AUTHOR : Prakash Software Solution Pvt Ltd.
/// @DATE : 09/10/24
/// @Message : [ReusableWidgets]
/// Commonly used widgets throughout application
/// should be placed here as static widget
class ReusableWidgets {
  static Widget buildTxtWidget(String txt) {
    return Text(txt);
  }

  /// ListView Builder with given ItemType Widget Builder
  static Widget buildListView(int itemCount, Widget Function(BuildContext, int) itemBuilder,
      {bool isSeparatorListView = false,
      Widget separatorWidget = const Divider(),
      EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
      bool shrinkWrap = true}) {
    return isSeparatorListView
        ? ListView.separated(
            itemBuilder: itemBuilder,
            separatorBuilder: (_, __) => separatorWidget,
            itemCount: itemCount,
            padding: padding,
            shrinkWrap: shrinkWrap,
          )
        : ListView.builder(
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            padding: padding,
            shrinkWrap: shrinkWrap,
          );
  }

  /// FutureBuilder Network Widget
  static Widget networkFutureBuilder(Widget child) {
    return FutureBuilder<bool>(
      future: NetworkUtils.instance.isConnected(),
      builder: (BuildContext ctx, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          /// TODO: Replace this Progress Bar Common UI Widget
          /// Wrapped with Material if no Material UI Component (Scaffold) is found in Navigation Stack
          return const Material(child: LoaderView());
        } else if (snapshot.hasData && snapshot.data != null && !snapshot.data!) {
          /// TODO: Replace this with actual Network Failure UI Widget
          return const ErrorPage(isNetworkError: true);
        } else if (snapshot.hasData && snapshot.data != null && snapshot.data == true) {
          return child;
        }
        return const SizedBox();
      },
    );
  }

  static Future<bool?> showConfirmationDialog(
    String title,
    String msg,
    void Function() func, {
    String? positiveBtnTitle,
    String? negativeBtnTitle,
  }) {
    bool tapResult = true;
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(title, textAlign: TextAlign.center,),
          backgroundColor: AppColors.backgroundColor,
          elevation: 10,
          content: Text(msg, textAlign: TextAlign.center,),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                tapResult = false;
                func.call();
              },
              child: Text(
                positiveBtnTitle ?? AppConstants.yesStr,
                style: FontTypography.chipStyle,
              ),
            ),
            TextButton(
              child: Text(
                negativeBtnTitle ?? AppConstants.noStr,
                style: FontTypography.chipStyle,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    ).then((_) {
      return tapResult;
    });
  }

  static Future<void> showConfirmationWithTwoFuncDialog(String title, String msg,
      {required void Function() funcYes, required void Function() funcNo, String? option1, String? option2}) {
    return showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Center(child: Text(title)),
          backgroundColor: AppColors.backgroundColor,
          elevation: 10,
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: funcYes,
              child: Text(
                option1 ?? AppConstants.yesStr,
                style: FontTypography.chipStyle,
              ),
            ),
            TextButton(
              onPressed: funcNo,
              child: Text(option2 ?? AppConstants.noStr, style: FontTypography.chipStyle),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showAlertDialog(
    String msg, {
    required void Function() funcOption1,
    required void Function() funcOption2,
    String? option1,
    String? option2,
  }) {
    return showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Center(
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: FontTypography.snackBarTitleStyle,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          // Replace with your background color
          elevation: 10,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBox20Height(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: funcOption1,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        // Replace with your color
                        backgroundColor: AppColors.whiteColor,
                        // Replace with your color
                        side: BorderSide(
                          color: AppColors.primaryColor, // Replace with your color
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(option1 ?? ''),
                    ),
                  ),
                  sizedBox10Width(), // Space between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: funcOption2,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.whiteColor,
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(option2 ?? ''),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  static Future<bool?> showConfirmationDialog2(
      String title,
      String msg,
      void Function() func, {
        String? positiveBtnTitle,
        String? negativeBtnTitle,
      }) {
    return showDialog<bool>(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: AppColors.backgroundColor,
          elevation: 10,
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                func();  // Call the function on positive button press
                Navigator.of(context).pop(true); // Return true on positive press
              },
              child: Text(
                positiveBtnTitle ?? AppConstants.yesStr,
                style: FontTypography.chipStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on negative press
              },
              child: Text(
                negativeBtnTitle ?? AppConstants.noStr,
                style: FontTypography.chipStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Return null for cancel button press
              },
              child: Text(
                "Cancel", // Default title for cancel button
                style: FontTypography.chipStyle,
              ),
            ),
          ],
        );
      },
    );
  }





  static Future<void> showLoaderDialog() {
    return showDialog(
      barrierDismissible: false,
      useSafeArea: false,
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.white.withOpacity(0.5),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            ),
          ),
        );
      },
    );
  }

  ///Image Builder added for displaying image and giving its path and checking if the image is from network or not
  ///giving image path to url in LoadNetwork image and displaying it if no image found or added it will display dummy
  /// image placeholder
  static Widget imageBuilder({required String? imagePath, bool? isNetworkImage}) {
    return Container(
      width: double.maxFinite,
      height: 110.0,
      margin: const EdgeInsets.only(top: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(constBorderRadius),
      ),
      child: Visibility(
        visible: isNetworkImage ?? false,
        replacement: Image.file(File(imagePath ?? ''), fit: BoxFit.cover),
        child: LoadNetworkImage(
          url: imagePath ?? '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static SvgPicture createSvg({
    required String path,
    double? size = 16,
    double? height,
    double? width,
    Color? color,
    BoxFit boxFit = BoxFit.contain,
  }) {
    /// Method to use svg images
    return SvgPicture.asset(
      path,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height ?? size,
      width: width ?? size,
      fit: boxFit,
    );
  }

  static Widget createNetworkSvg({
    required String path,
    double? size = 16,
    double? height,
    double? width,
    Color? color,
    BoxFit boxFit = BoxFit.contain,
  }) {
    final isNetwork = Uri.tryParse(path)?.hasAbsolutePath ?? false;

    if (isNetwork) {
      return SvgPicture.network(
        path,
        height: size,
        width: size,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        fit: boxFit,
      );
    } else {
      return SvgPicture.asset(
        path,
        height: size,
        width: size,
        fit: boxFit,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,

      );
    }
  }


  static Divider createDivider({double? thickness}) {
    return Divider(thickness: thickness ?? 0.3, height: 0);
  }

  static createCircularShadowBox({
    Function()? onIconClick,
    required String iconPath,
    double? iconSize = 20,
    double? boxSize = 32,
    double? elevation = 3,
  }) {
    return SizedBox(
      height: boxSize,
      width: boxSize,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // White background for the button
          padding: const EdgeInsets.symmetric(vertical: 4), // Button padding
          elevation: elevation, // Elevation for shadow effect
        ),
        onPressed: () => onIconClick?.call(), // Action for the button (currently empty)
        child: createSvg(size: iconSize ?? 20, path: iconPath), // Icon inside the button
      ),
    );
  }

  static Widget searchWidget({
    required void Function(String) onSubmit,
    required void Function(String) onChanged,
    required Stream<bool>? stream,
    int? maxLines,
    required void Function()? onCancelClick,
    required void Function()? onSearchIconClick,
    required TextEditingController txtController,
    String? hintTxt,
  }) {
    return AppTextField(
      height: 45,
      maxLines: maxLines,
      hintTxt: hintTxt ?? AppConstants.searchStr,
      hintStyle: FontTypography.textFieldBlackStyle.copyWith(fontSize: 14.0),
      onChanged: onChanged,
      textCapitalization: TextCapitalization.none,
      suffixIconConstraints: const BoxConstraints(
        minHeight: 25,
        maxHeight: 25,
        minWidth: 65,
        maxWidth: 65,
      ),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder(
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data ?? false) {
                return InkWell(
                  /// clear data on tap of clear button
                  onTap: onCancelClick,
                  child: SizedBox(
                    height: 39,
                    width: 35,
                    child: Icon(Icons.clear, color: AppColors.jetBlackColor),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          InkWell(
            ///search data on click of search button
            onTap: onSearchIconClick,
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.all(5),
              height: 39,
              child: ReusableWidgets.createSvg(
                width: 15,
                height: 15,
                path: AssetPath.searchIconSvg,
              ),
            ),
          ),
        ],
      ),
      controller: txtController,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onSubmit: onSubmit,
      fillColor: AppColors.locationButtonBackgroundColor,
    );
  }

  static Widget createBottomSheetBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 7,
        width: 59,
        decoration: BoxDecoration(
          color: AppColors.bottomSheetBarColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  static Widget accountType( context,  state,cubit,accountType) {

    final accountTypeOptions = {
      EnumType.businessAccountType: AppConstants.businessStr,
      EnumType.personalAccountType: AppConstants.personalStr,
    };

    return DropdownButtonHideUnderline(
      child: DropdownButton2<int>(
        isExpanded: true,
        hint: Text(AppConstants.accountType,
            style: FontTypography.textFieldHintStyle),
        customButton: Container(
          height: AppConstants.constTxtFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(constBorderRadius),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  accountTypeOptions[state.accountType] ?? accountType??
                      AppConstants.selectAccountType,
                  style: FontTypography.textFieldHintStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(AssetPath.iconDropDown),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
          ),
        ),
        items: accountTypeOptions.entries.map(
              (entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Row(
                children: [
                  // Add icon based on the entry key
                  ReusableWidgets.createSvg(
                    path: entry.key == 1
                        ? AssetPath.personalAccountTypeIcon
                        : AssetPath.businessAccountTypeIcon,
                    color: AppColors.blackColor,
                  ),
                  const SizedBox(width: 10), // Space between icon and text
                  Text(
                    entry.value, // Display the corresponding string
                    style: FontTypography.textFieldBlackStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ).toList(),
        value: state.accountType,
        onChanged: (int? value) async {
          cubit.accountTypeChange(value ?? 0);
        },
      ),
    );
  }
}
