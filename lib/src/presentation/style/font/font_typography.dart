import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/constants.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04/09/24
/// @Message : [FontTypography]

class FontTypography {
  /// Default Text Style
  static TextStyle defaultTextStyle = TextStyle(
    fontSize: 14.0,
    color: AppColors.blackColor,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontFamily: AppConstants.fontFamilyDMSans,
  );

  static TextStyle defaultLightTextStyle = TextStyle(
    fontSize: 14.0,
    color: AppColors.blackColor,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    fontFamily: AppConstants.fontFamilyDMSans,
  );

  static TextStyle textFieldGreyTextStyle = TextStyle(
    color: AppColors.lightGreyColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bottomSheetGreyTextStyle = TextStyle(
    color: AppColors.lightGreyColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textFieldBlackStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textFieldsValueStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 18.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textFieldHintStyle = TextStyle(
    color: AppColors.hintStyle,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle alreadyHaveAccountStyle = TextStyle(
    color: AppColors.hintStyle,
    fontSize: 18.0,
    fontFamily: AppConstants.fontFamilyDMSans,
  );

  static TextStyle snackBarTitleStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w600,
  );

  static TextStyle snackBarButtonStyle = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tabBarStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle addressStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w500,
  );

  static TextStyle listingTimeStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle listingTimeStyleGreen = TextStyle(
    color: AppColors.greenColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle appBarStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w500,
  );

  static TextStyle subTitleStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 20.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w600,
  );

  static TextStyle signInBoldStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 20.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w900,
  );

  static TextStyle subTextStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle subTextBoldStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w700,
  );

  static TextStyle insightTextBoldStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w500,
  );

  static TextStyle forgetPassStyle = TextStyle(
    color: AppColors.forgotPasswordColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle signUpRouteStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle appBtnStyle = const TextStyle(
    color: Colors.white,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
  );

  static TextStyle socialBtnStyle = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bottomSheetHeading = TextStyle(
    color: AppColors.blackColor,
    fontSize: 22.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w700,
  );

  static TextStyle subString = TextStyle(
    color: AppColors.passwordEyeColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileTitleString = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w300,
  );

  static TextStyle profileHeading = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 22.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle profileTitleHeading = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 22.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileSUbTitle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle basicDetailsTitle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 26.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle basicDetailsTextFieldStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );

  static TextStyle basicDetailsTextValueStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w500,
  );
  static TextStyle sortByTitle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle listingStatTxtStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle enquiryNameTxtStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static TextStyle enquiryCityTxtStyle = TextStyle(
    color: AppColors.subTextColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle reviewTimeTxtStyle = TextStyle(
    color: AppColors.datetimeColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle locationTextStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 10.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle listingTitleTextStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 20.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle subscriptionTxtStyle = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 24.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle planTxtStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static TextStyle dateTimeTxtStyle = TextStyle(
    color: AppColors.subTextColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle itemDetailsGridViewStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 10.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle appBarWithoutBack = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 16.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle itemRatingTxtStyle = TextStyle(
    color: AppColors.subTextColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle reachOutTxtStyle = TextStyle(
    color: AppColors.subTextColor,
    fontSize: 13.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle reviewTxtStyle = TextStyle(
      color: AppColors.subTextColor,
      fontSize: 12.0,
      fontFamily: AppConstants.fontFamilyDMSans,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);

  static TextStyle categoryTagTxtStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle forSaleTagTxtStyle = TextStyle(
    color: AppColors.forSaleColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static TextStyle priceTxtStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 26.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle discountedPriceTxtStyle = TextStyle(
      color: AppColors.subTextColor,
      fontSize: 14.0,
      fontFamily: AppConstants.fontFamilyDMSans,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.lineThrough);

  static TextStyle priceRangeStyle = TextStyle(
    color: AppColors.subTextColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle popupMenuTxtStyle = TextStyle(
      color: AppColors.jetBlackColor,
      fontSize: 18.0,
      fontFamily: AppConstants.fontFamilyDMSans,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400);

  static TextStyle aboutUsTxtStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle subDetailsTxtStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle listingFormTitleStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 26.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle listingFormSubTitleStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle advanceScreenSortByStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle uploadMsgTextStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 10.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle statisticsTitleStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 18.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w700,
  );

  static TextStyle changeEmailHeadingStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 22.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w700,
  );
  static TextStyle likeCountStyle = TextStyle(
    color: AppColors.subTextColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle answerTextStyle = TextStyle(
    color: AppColors.subTextColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle priceStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );
  static TextStyle chipStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w500,
  );
  static TextStyle addAccountStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );
  static TextStyle cvStyle = TextStyle(
      color: AppColors.jetBlackColor,
      fontSize: 13.0,
      fontFamily: AppConstants.fontFamilyDMSans,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w300);

  static TextStyle purchaseStyle = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
  static TextStyle editTextStyle = TextStyle(
      color: AppColors.primaryColor,
      fontSize: 13.0,
      fontFamily: AppConstants.fontFamilyDMSans,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);

  static TextStyle ratingNumberTxtStyle = TextStyle(
    color: AppColors.jetBlackColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static TextStyle upgradeSubscriptionButtonText = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
  static TextStyle cancelSubscriptionButtonText = TextStyle(
    color: AppColors.deleteColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle activeListingTextStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 20.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle promoCodeListFont = TextStyle(
    color: AppColors.lightGreyColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );
  static TextStyle promoCodeFont = TextStyle(
    color: AppColors.promoCodeColor,
    fontSize: 12.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );
  static TextStyle amountStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w400,
  );static TextStyle discountStyle = TextStyle(
    color: AppColors.greenColor,
    fontSize: 14.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontWeight: FontWeight.w300,
  );
  static TextStyle categoryCardTextStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 10.0,
    fontFamily: AppConstants.fontFamilyDMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
}
