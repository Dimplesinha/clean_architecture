import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/data/storage/storage.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/advance_search_item_model.dart';
import 'package:workapp/src/domain/models/advance_search_model.dart';
import 'package:workapp/src/domain/models/advance_search_sub_model.dart';
import 'package:workapp/src/domain/models/location_details.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_regex.dart';
import 'package:workapp/src/utils/date_time_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04/09/24
/// @Message : [AppUtils]
///

GlobalKey<ScaffoldState> bottomSheetKey = GlobalKey<ScaffoldState>();

class AppUtils {
  static final AppUtils _singleton = AppUtils._internal();

  AppUtils._internal();

  static AppUtils get instance => _singleton;

  static String deviceUDID = '';
  static LoginModel? loginUserModel;
  static CategoriesList? categoryList;

  /// Error snack bar

  static showErrorSnackBar(String msg) {
    snackBarKey.currentState?.clearSnackBars();
    final SnackBar snackBar = SnackBar(content: Text(msg));
    snackBarKey.currentState?.showSnackBar(snackBar);
  }

  /// Common SnackBar
  static showSnackBar(String msg, SnackBarType? type, {BuildContext? ct}) {
    IconSnackBar.show(
      ct ?? navigatorKey.currentState!.context,
      label: msg,
      snackBarType: type ?? SnackBarType.alert,
      maxLines: 5,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
  }

  static showFormErrorSnackBar({required String msg, BuildContext? context}) {
    IconSnackBar.show(context ?? navigatorKey.currentState!.context,
        label: msg, snackBarType: SnackBarType.fail, maxLines: 3);
  }

  ///BottomSheet
  static showBottomSheet(
    context, {
    required Widget child,
    Function()? onCancel,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: isDismissible,
      // Prevents closing on tap outside
      enableDrag: enableDrag,
      // Prevents dragging down to close
      context: context,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          key: bottomSheetKey,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: TapRegion(
              onTapOutside: (_) => isDismissible ? navigatorKey.currentState?.pop() : null,
              child: child,
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (onCancel != null) {
        onCancel();
      }
    });
  }

  static showBottomSheetForDashboard(
    context, {
    required Widget child,
    Function()? onCancel,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      context: context,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      builder: (BuildContext context) {
        return SafeArea(
          // Ensures bottom padding
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: bottomSheetKey,
            body: Align(
              alignment: Alignment.bottomCenter,
              child: TapRegion(
                onTapOutside: (_) => isDismissible ? navigatorKey.currentState?.pop() : null,
                child: child,
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (onCancel != null) {
        onCancel();
      }
    });
  }

  static showBottomSheetWithData(context,
      {required Widget child,
      Function()? onCancel,
      Function(String)? onCancelWithData,
      bool isDismissible = true,
      bool enableDrag = true}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      context: context,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: child,
        );
      },
    ).then((value) {
      if (value != null) {
        var msg = value as String;
        onCancelWithData!(msg);
      } else {
        onCancel!();
      }
    });
  }

  static String getDateTimeFromTimestamp(int? timestamp) {
    // Convert the timestamp to DateTime
    if (timestamp != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();

      // Define your desired format
      DateFormat formatter = DateFormat('dd-MM-yyyy');

      // Convert to string
      return formatter.format(dateTime);
    }
    return '';
  }

  static int getTimestampFromDate(DateTime date) {
    // Convert DateTime to milliseconds since epoch (timestamp)
    return date.millisecondsSinceEpoch;
  }

  static String getDateTimeFormated(DateTime? dateTime) {
    // Convert the timestamp to DateTime
    if (dateTime != null) {
      // Define your desired format
      DateFormat formatter = DateFormat('yyyy');

      // Convert to string
      return formatter.format(dateTime);
    }
    return '';
  }

  static String groupMessageDateAndTime1(String time) {
    // Parse and convert UTC time to local
    DateTime dt = DateTime.parse(time);
    DateTime utcDateTime = DateTime.utc(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
      dt.millisecond,
    ).toLocal();

    DateTime now = DateTime.now();
    Duration diff = now.difference(utcDateTime);

    // Extract date parts for comparison
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime messageDate = DateTime(utcDateTime.year, utcDateTime.month, utcDateTime.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    // Logic mimicking getTimeAgo

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 5) return '${diff.inMinutes} min ago';


    if (messageDate == today) {
      return DateFormat('hh:mm a').format(utcDateTime);

    } else if (messageDate == yesterday ) {
      return 'Yesterday';
    } else if (diff.inDays < 7 ) {
      return DateFormat('EEEE').format(utcDateTime); // e.g., Monday, Tuesday
    } else {
      return /*isFromChatListing
          ? DateFormat('dd-MM-yy').format(utcDateTime)
          :*/ DateFormat('dd-MM-yyyy').format(utcDateTime);
    }
  }


  static String groupMessageDateAndTime(String time, {bool isFromChatListing = false}) {
    // Parse the input time string to DateTime object
    DateTime dt = DateTime.parse(time);

    // Convert the parsed time to UTC and then to the local timezone
    DateTime utcDateTime = DateTime.utc(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
      dt.millisecond,
    ).toLocal();

    // Get today's date without time for comparison
    final todayDate = DateTime.now();
    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);

    // Get yesterday's date without time for comparison
    final yesterday = DateTime(todayDate.year, todayDate.month, todayDate.day - 1);

    // Initialize the result string
    String difference = '';

    // Get the date from the utcDateTime without time
    final aDate = DateTime(utcDateTime.year, utcDateTime.month, utcDateTime.day);

    if (aDate == today) {
      // If the message is from today, show the time in HH:mm format
      difference = DateFormat('hh:mm a').format(utcDateTime);
    } else if (aDate == yesterday && isFromChatListing) {
      // If the message is from yesterday, show "Yesterday"
      difference = 'Yesterday';
    } else {
      // For other dates, show the formatted date (e.g., Sep 12, 2024)
      if (isFromChatListing) {
        difference = DateFormat('dd-MM-yy').format(utcDateTime).toString();
      } else {
        difference = DateFormat('dd-MM-yy hh:mm a').format(utcDateTime).toString();
      }
    }

    return difference;
  }

  static String currentDateTime(String time) {
    // Parse the input time string to DateTime object
    if (time.isNotEmpty && time != '') {
      try {
        DateTime dt = DateTime.parse(time);
        // Convert the parsed time to UTC and then to the local timezone
        DateTime utcDateTime = DateTime.utc(
          dt.year,
          dt.month,
          dt.day,
          dt.hour,
          dt.minute,
          dt.second,
          dt.millisecond,
        ).toLocal();

        // Format the date as "MMM-dd-yyyy hh:mm a" (e.g., Jan-18-2024 06:43 pm)
        String formattedDate = DateFormat('MMM-dd-yyyy hh:mm a').format(utcDateTime);

        return formattedDate;
      } catch (e) {
        // Return the original date if parsing fails
        return time;
      }
    }
    return time;
  }

  static String formatTimestamp(String timestamp) {
    // Parse the input string to DateTime
    DateTime dateTime = DateTime.parse(timestamp).toLocal(); // Converts to local time zone

    // Format DateTime to 'h:mm a' format (e.g., 6:36 PM)
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }

  static elevatedCircleAvatar({
    required String path,
    double? height,
    double? width,
    double? size,
    required double iconSize,
    Color? backgroundColor,
    Color? iconColor,
    Function()? onPressed,
    double? elevation,
  }) {
    return SizedBox(
      height: size ?? height ?? 32,
      width: size ?? width ?? 32,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: backgroundColor ?? AppColors.whiteColor, // White background for the button
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5), // Button padding
          elevation: elevation ?? 3, // Elevation for shadow effect
        ),
        onPressed: onPressed ?? () => log('$path Pressed'), // Action for the button (currently empty)
        child: ReusableWidgets.createSvg(path: path, size: iconSize, color: iconColor), // Icon inside the button
      ),
    );
  }

  static List<Widget> buildStarIcons(double rating, {double iconSize = 14.0}) {
    List<Widget> stars = [];

    // Add full stars
    for (int i = 1; i <= rating.floor(); i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: iconSize));
    }

    // Add half star if there's a fraction
    if (rating % 1 != 0) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: iconSize));
    }

    // Add empty stars to make a total of 5 stars
    for (int i = stars.length; i < 5; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: iconSize));
    }

    return stars;
  }

  static Color getRatingColor(String label) {
    switch (label) {
      case AppConstants.excellentStr:
        return AppColors.excellentRatingColor;
      case AppConstants.goodStr:
        return AppColors.goodRatingColor;
      case AppConstants.avgStr:
        return AppColors.avgRatingColor;
      case AppConstants.belowAvgStr:
        return AppColors.belowAvgRatingColor;
      case AppConstants.poorStr:
        return AppColors.deleteColor;
      default:
        return AppColors.progressBgColor;
    }
  }

  static int getActivityId({required String activityType}) {
    switch (activityType) {
      case AppConstants.callStr:
        return 1;
      case AppConstants.emailStr:
        return 2;
      case AppConstants.messageStr:
        return 3;
      case AppConstants.websiteStr:
        return 4;
      default:
        return 0;
    }
  }

  static int getDeviceTypeId() {
    if (Platform.isAndroid) {
      return 3;
    } else if (Platform.isIOS) {
      return 2;
    } else {
      return 1;
    }
  }

  static Widget tabButton(
      BuildContext context, int index, String path, String label, int? selectedIndex, PageController pageController) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          pageController.jumpToPage(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(
              width: 0.7,
              color: AppColors.tabBorderColor,
            ),
          ),
          child: Column(
            children: [
              ReusableWidgets.createSvg(
                  path: path, color: isSelected ? AppColors.primaryColor : AppColors.blackColor, size: 16),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: isSelected
                    ? FontTypography.tabBarStyle.copyWith(color: AppColors.primaryColor)
                    : FontTypography.tabBarStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// banner UI
  static Widget simpleBanner({required String bannerUrl}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.locationButtonBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(bannerUrl),
            fit: BoxFit.cover,
          )),
    );
  }

  static showAlertDialog(BuildContext context,
      {required String title,
      required String description,
      required String confirmationText,
      bool barrierDismissible = true,
      required void Function() onOkPressed}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            title,
            style: FontTypography.textFieldBlackStyle,
          ),
          content: Text(
            description,
            style: FontTypography.defaultLightTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: onOkPressed,
              child: Text(
                confirmationText,
                style: FontTypography.bottomSheetGreyTextStyle.copyWith(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // This functions is used to get device unique ID
  static void getDeviceID() async {
    //String deviceID;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceUDID = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceUDID = iosInfo.identifierForVendor ?? '';
    }
    if (kDebugMode) {
      print('_deviceID -->$deviceUDID');
    }
  }

  ///This is used for converting country code to flag for display on UI

  static String getFlag(String countryCode) {
    var country = countries.where((element) {
      return element.code == countryCode;
    }).toList();
    return country.isNotEmpty ? country.first.flag : '';
  }

  static Future<String> getCountry() async {
    String countryIosCode = 'US';

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return countryIosCode;
    }

    // Request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return countryIosCode;
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Convert coordinates to country
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      countryIosCode = placemarks[0].isoCountryCode ?? 'US';
    }
    return countryIosCode;
  }

  /// Extracting latitude and longitude of user
  // static Future<Map<String, double>> getLatLong() async {
  //   Map<String, double> latLong = {};
  //   var locationPermissionStatus = await Permission.location.status;
  //   if (locationPermissionStatus == PermissionStatus.granted) {
  //     var location = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
  //     latLong.update(ModelKeys.latitude, (_) => location.latitude, ifAbsent: () => location.latitude);
  //     latLong.update(ModelKeys.longitude, (_) => location.longitude, ifAbsent: () => location.longitude);
  //   } else {
  //     latLong.update(ModelKeys.latitude, (_) => 0.0, ifAbsent: () => 0.0);
  //     latLong.update(ModelKeys.longitude, (_) => 0.0, ifAbsent: () => 0.0);
  //     await AppUtils.requestLocationPermission().then((value) {
  //       if (value) {
  //         var location = Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
  //         location.then((location) {
  //           latLong.update(ModelKeys.latitude, (_) => location.latitude, ifAbsent: () => location.latitude);
  //           latLong.update(ModelKeys.longitude, (_) => location.longitude, ifAbsent: () => location.longitude);
  //         });
  //       }
  //     });
  //   }
  //   return latLong;
  // }

  // static Future<Map<String, double>> getLatLong() async {
  //   Map<String, double> latLong = {
  //     ModelKeys.latitude: 0.0,
  //     ModelKeys.longitude: 0.0,
  //   };
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //
  //   if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
  //     Position location = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
  //     latLong[ModelKeys.latitude] = location.latitude;
  //     latLong[ModelKeys.longitude] = location.longitude;
  //   }
  //
  //   return latLong;
  // }

  static Map<String, double>? _cachedLatLong;
  static Future<Map<String, double>>? _latLongFuture;

  static Future<Map<String, double>> getLatLong({bool forceRefresh = false}) {
    if (!forceRefresh && _cachedLatLong != null) {
      return Future.value(_cachedLatLong);
    }

    if (!forceRefresh && _latLongFuture != null) {
      return _latLongFuture!;
    }

    // Create a shared future to avoid multiple parallel executions
    _latLongFuture = _fetchLatLong();
    return _latLongFuture!;
  }

  static Future<Map<String, double>> _fetchLatLong() async {
    Map<String, double> latLong = {
      ModelKeys.latitude: 0.0,
      ModelKeys.longitude: 0.0,
    };

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Position location = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        latLong[ModelKeys.latitude] = location.latitude;
        latLong[ModelKeys.longitude] = location.longitude;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }

    _cachedLatLong = latLong;

    // Clear future so new calls can re-trigger fetch if needed
    Future.delayed(const Duration(milliseconds: 10), () {
      _latLongFuture = null;
    });

    return latLong;
  }

  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }

    return false;
  }

  // Format time as HH:mm (24-hour format) or hh:mm a (12-hour format)
  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt); // Change to 'HH:mm' for 24-hour format
  }

  // Format time as HH:mm (24-hour format)
  static String formatTime24HrHHMM(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  static String formatTime24Hr(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static String? formatTime12Hr(String? time24Hr) {
    // Check if the input is null or empty
    if (time24Hr == null || time24Hr.isEmpty) {
      return null; // Return null or a fallback value if needed
    }

    try {
      // Parse the 24-hour time string
      final List<String> parts = time24Hr.split(':');
      if (parts.length < 2) {
        return null; // Return null if input is invalid
      }

      int hour = int.parse(parts[0]); // Extract the hour
      int minute = int.parse(parts[1]); // Extract the minutes

      // Determine AM/PM
      String period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      hour = hour % 12;
      if (hour == 0) hour = 12; // Handle midnight and noon

      // Format the output
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      // Handle parsing errors
      return null; // Return null or a fallback value if needed
    }
  }

  /// get Notification of email and push
  static String getNotification(bool emailNotification, bool pushNotification) {
    if (emailNotification && !pushNotification) {
      return AppConstants.emailStr;
    } else if (!emailNotification && pushNotification) {
      return AppConstants.mobileStr; // Mobile only
    } else if (emailNotification && pushNotification) {
      return AppConstants.bothStr; // Both Email and Mobile
    } else {
      return '';
    }
  }

  /// get Notification of email and push
  static int getAccountType(String value) {
    if (value == AppConstants.businessStr) {
      return EnumType.businessAccountType;
    } else if (value == AppConstants.personalStr) {
      return EnumType.personalAccountType; // Mobile only
    } else {
      return 0;
    }
  }

  static String getAccountTypeString(int value) {
    if (value == EnumType.businessAccountType) {
      return AppConstants.businessStr;
    } else if (value == EnumType.personalAccountType) {
      return AppConstants.personalStr; // Mobile only
    } else {
      return '';
    }
  }

  static String getGenderFromCode(String? code) {
    switch (code?.trim().toUpperCase()) {
      case 'M' || 'Male' || 'MALE':
        return 'Male';
      case 'F' || 'Female' || 'FEMALE':
        return 'Female';

      default:
        return ''; // Fallback if the code is not recognized
    }
  }

  static (CurrentFileType, CurrentFileOrigin) getFileTypeAndOrigin({required String filePath}) {
    /// Checking if the file is Image or video
    if (filePath.contains(FormValidationRegex.imagePatternRegex)) {
      /// Checking if the image is network Image or Local Image
      if (filePath.contains(FormValidationRegex.networkUrlRegex)) {
        /// Network Image
        return (CurrentFileType.image, CurrentFileOrigin.network);
      } else {
        /// Local Image
        return (CurrentFileType.image, CurrentFileOrigin.local);
      }
    } else if (filePath.contains(FormValidationRegex.videoPatternRegex)) {
      /// Checking if the video is network video or Local video
      if (filePath.contains(FormValidationRegex.networkUrlRegex)) {
        /// Network Image
        return (CurrentFileType.video, CurrentFileOrigin.network);
      } else {
        /// Local Image
        return (CurrentFileType.video, CurrentFileOrigin.local);
      }
    } else {
      return (CurrentFileType.other, CurrentFileOrigin.local);
    }
  }

  static Future<File?> generateThumbnail(String videoUrl) async {
    try {
      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      // Generate the thumbnail
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.PNG,
        //  maxHeight: 150,
        timeMs: 2000,
        // specify the height of the thumbnail
        quality: 10,
      );
      var thumbnailPath = thumbnail.path;
      return File(thumbnailPath); // Return the thumbnail as a File
    } catch (e) {
      if (kDebugMode) {
        print('Error generating thumbnail: $e');
      }
      return null;
    }
  }

  static bool checkPhoneNo(String countryCode, String phoneNumber) {
    var country = countries.where((element) {
      return element.code == countryCode;
    }).toList();
    var minLength = country.first.minLength;
    var maxLength = country.first.maxLength;
    final effectiveLength = phoneNumber.startsWith('0') ? phoneNumber.length - 1 : phoneNumber.length;

    if (effectiveLength < minLength || effectiveLength > maxLength) {
      return false;
    } else {
      return true;
    }
  }

  static Future<File?> renameFileWithTimestamp(File file) async {
    if (await file.exists()) {
      final directory = file.parent.path;
      final extension = file.path.split('.').last;
      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final newPath = '$directory/$timestamp.$extension';

      try {
        return await file.rename(newPath);
      } catch (e) {
        if (kDebugMode) {
          print('Error renaming file: $e');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        print('File does not exist at path: ${file.path}');
      }
      return null;
    }
  }

  static bool isImageFile(String filePath) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic'];
    final extension = filePath.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  static bool isVideoFile(String filePath) {
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'];
    final extension = filePath.split('.').last.toLowerCase();
    return videoExtensions.contains(extension);
  }

  static String timeAgo(String dateString) {
    if (dateString.isEmpty) {
      return '';
    }

    DateTime itemDate;
    try {
      itemDate = DateTime.parse(dateString);
      itemDate = DateTime.utc(
        itemDate.year,
        itemDate.month,
        itemDate.day,
        itemDate.hour,
        itemDate.minute,
        itemDate.second,
        itemDate.millisecond,
      );
    } catch (e) {
      return '';
    }

    final currentLocalTime = DateTime.now();
    final localDate = itemDate.toLocal();

    final difference = currentLocalTime.difference(localDate);

    final years = difference.inDays ~/ 365;
    if (years > 0) return '$years year${years > 1 ? 's' : ''} ago';

    final months = difference.inDays ~/ 30;
    if (months > 0) return '$months month${months > 1 ? 's' : ''} ago';

    final days = difference.inDays;
    if (days > 0) return '$days day${days > 1 ? 's' : ''} ago';

    final hours = difference.inHours;
    if (hours > 0) return '$hours hr${hours > 1 ? 's' : ''} ago';

    final minutes = difference.inMinutes;
    if (minutes > 0) return '$minutes min${minutes > 1 ? 's' : ''} ago';

    final seconds = difference.inSeconds;
    if(seconds == 0){
      return 'Just Now';
    }
    return '$seconds sec${seconds > 1 ? 's' : ''} ago';
  }

  static String? formatDate(String? date) {
    if (date != null && date.isNotEmpty) {
      try {
        final DateTime parsedDate = DateTime.parse(date);
        return DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        // Return the original date if parsing fails
        return date;
      }
    }
    return date;
  }

  static String? formatDateLocal(String? date) {
    if (date != null && date.isNotEmpty) {
      try {
        final DateTime parsedDate = DateTime.parse(date).toLocal();
        return DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        // Return the original date if parsing fails
        return date;
      }
    }
    return date;
  }

  static String promoDateRange(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      DateTime requiredDate = DateTime.utc(
        date.year,
        date.month,
        date.day,
        now.hour,
        now.minute,
        now.second,
      );
      return requiredDate.toIso8601String();
    } catch (e) {
      // Optional: Log or handle the parsing error
      return '';
    }
  }


  static String? formatDateInServerFormat(String? date) {
    if (date != null && date.isNotEmpty) {
      try {
        // If the string contains a comma, handle it as a range
        if (date.contains(',')) {
          final parts = date.split(',');
          if (parts.length == 2) {
            final startDate = DateTime.parse(parts[0].trim());
            final endDate = DateTime.parse(parts[1].trim());
            final formattedStart = DateFormat('dd/MM/yyyy').format(startDate);
            final formattedEnd = DateFormat('dd/MM/yyyy').format(endDate);
            return '$formattedStart - $formattedEnd';
          }
        } else {
          final parsedDate = DateTime.parse(date.trim());
          return DateFormat('dd/MM/yyyy').format(parsedDate);
        }
      } catch (e) {
        // Return the original if parsing fails
        return date;
      }
    }
    return date;
  }


  static String? formatDateInServerFormatWithTime(String? date) {
    if (date != null && date.isNotEmpty) {
      try {
        // Parse the input date as UTC
        final DateTime utcDate = DateTime.parse(date);
        // Convert to local time zone
        final DateTime localDate = utcDate.toLocal();
        // Format the local date
        return DateFormat('dd/MM/yyyy hh:mm').format(localDate);
      } catch (e) {
        // Log the error for debugging (optional)
        print('Error parsing date: $e');
        // Return the original date if parsing fails
        return date;
      }
    }
    return date;
  }

  static String formatTimeToHHMM(String? time) {
    if (time != null && time.isNotEmpty) {
      try {
        List<String> timeArray = time.split(':');
        return '${timeArray[0]}:${timeArray[1]}';
      } catch (e) {
        // Return the original date if parsing fails
        return time;
      }
    }
    return time ?? '';
  }
  static String formatTimeRangeDisplay(String? timeRange) {
    if (timeRange == null || timeRange.isEmpty) return '';

    try {
      final parts = timeRange.split(',');
      if (parts.length == 2) {
        final fromTime = _formatSingleTime(parts[0].trim());
        final toTime = _formatSingleTime(parts[1].trim());
        return '$fromTime - $toTime';
      }
      return timeRange;
    } catch (e) {
      return timeRange;
    }
  }

  static String _formatSingleTime(String time) {
    try {
      // Handle input like "2:51PM", "14:00", etc.
      final timeFormatted = DateFormat.jm().parseLoose(time);
      return DateFormat.jm().format(timeFormatted); // Outputs like "2:51 PM"
    } catch (_) {
      return time; // Fallback if parsing fails
    }
  }


  static String formatPromoDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      // Return the original date if parsing fails
      return date;
    }
  }

  static String formatTimeToAmPm(String time) {
    try {
      // Parse the input time string
      final DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
      // Format the time to 12-hour format with AM/PM
      return DateFormat('hh:mm a').format(parsedTime);
    } catch (e) {
      // Return the original time if parsing fails
      return time;
    }
  }

  static Future<String> formatPriceRange({
    required String priceFrom,
    required String priceTo,
    required String currencyCode,
  }) async {
    var countryData = await PreferenceHelper.instance.getCountryList();
    String? currencySymbol = '';

    // Check if currencyCode is empty
    if (currencyCode.isEmpty) {
      String defaultLocale = getDeviceLocale();
      // Fetch the default currency symbol from the device locale
      final format = NumberFormat.simpleCurrency(locale: defaultLocale);
      currencySymbol = format.currencySymbol;
      currencyCode = format.currencyName ?? ''; // Use the default currency code if available
    } else {
      // Retrieve currency symbol from the country data
      var country = countryData.result!.firstWhere(
        (country) => country.currencyCode == currencyCode,
      );
      currencySymbol = country.currencySymbol;
    }

    final formattedFrom = priceFrom; // Format priceFrom
    final formattedTo = priceTo; // Format priceTo

    String finalDisplayPrice = '';
    if (formattedFrom.isNotEmpty && formattedTo.isNotEmpty) {
      finalDisplayPrice = '$currencySymbol $formattedFrom - $currencySymbol $formattedTo $currencyCode';
      return finalDisplayPrice;
    } else if (formattedTo.isNotEmpty) {
      finalDisplayPrice = '$currencySymbol $formattedTo $currencyCode';
      return finalDisplayPrice;
    } else if (formattedFrom.isNotEmpty) {
      finalDisplayPrice = '$currencySymbol $formattedFrom $currencyCode';
      return finalDisplayPrice;
    }

    return finalDisplayPrice;
  }

  static Future<String?> formatCurrency({required String currencyCode}) async {
    try {
      var countryData = await PreferenceHelper.instance.getCountryList();
      String? currencySymbol = '';

      if (currencyCode.isEmpty) {
        // Fetch default locale and its currency symbol
        String defaultLocale = getDeviceLocale();
        final format = NumberFormat.simpleCurrency(locale: defaultLocale);
        currencySymbol = format.currencySymbol;
        currencyCode = format.currencyName ?? ''; // Default currency code if available
      } else {
        // Find the matching currency code in the country data
        var country = countryData.result?.firstWhere(
          (country) => country.currencyCode == currencyCode,
        );

        // Assign currency symbol if found, otherwise use an empty string
        currencySymbol = country?.currencySymbol ?? '';
      }

      return currencySymbol;
    } catch (e) {
      // Handle errors gracefully
      if (kDebugMode) {
        print('Error in formatCurrency: $e');
      }
      return null;
    }
  }

  static String getDeviceLocale() {
    Locale locale = Localizations.localeOf(navigatorKey.currentContext!);
    return locale.toString(); // returns the locale in "en_US" format
  }

  static dynamic getIdByValue({
    required Map<int, String> map,
    required String? value,
  }) {
    if (value != null && value.isNotEmpty) {
      try {
        // Ensure the comparison is robust (case-insensitive and trimmed)
        final keyForValue = map.entries
            .firstWhere(
              (entry) => entry.value.toString().trim().toLowerCase() == value.trim().toLowerCase(),
              orElse: () => const MapEntry(-1, ''), // Use the same types as the map
            )
            .key;

        return keyForValue == -1 ? null : keyForValue; // Return null if not found
      } catch (e) {
        // Log the error for debugging
        if (kDebugMode) {
          print('Error finding value: $e');
        }
      }
      return null;
    }
  }

  bool dateCheck(String date) {
    if (date.isEmpty) {
      return true;
    }
    DateTime dt = DateTime.parse(date);
    DateTime utcDateTimeDt = DateTime.utc(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
      dt.millisecond,
    ).toLocal();
    DateTime now = DateTime.now();
    DateTime utcDateTimeNow = DateTime.utc(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
    ).toLocal();

    Duration difference = utcDateTimeNow.difference(utcDateTimeDt);

    // Determine if the edit icon should be visible (within 24 hours)
    if (difference.inHours <= 24) {
      return true;
    } else {
      return false;
    }
  }

  /// Extracting latitude, longitude, and address details
  static Future<LocationDetails?> getLocationDetails() async {
    try {
      // Check location permission
      var locationPermissionStatus = await Permission.location.status;
      if (locationPermissionStatus != PermissionStatus.granted) {
        await AppUtils.requestLocationPermission();
        return null; // Return null if permission not granted
      }

      // Get current location
      var location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Use Geocoding to get address information
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return LocationDetails(
          address: place.street ?? '',
          city: place.locality ?? '',
          state: place.administrativeArea ?? '',
          country: place.country ?? '',
        );
      } else {
        return LocationDetails(address: '', city: '', state: '', country: '');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching location details: $e');
      }
      return null;
    }
  }

  ///Used to get meta data from item.
  static getMetaData(AdvanceSearchItem item) {
    LinkedHashMap<String, String>? hashMap = LinkedHashMap();
    if (item.categoryName?.isNotEmpty == true) {
      hashMap[AppConstants.category] = item.categoryName!;
    } else {
      hashMap[AppConstants.category] = AppConstants.allStr;
    }

    if (item.keyword?.isNotEmpty == true) {
      hashMap[AppConstants.keywordHintStr] = item.keyword!;
    }

    if (item.visibilityType != null) {
      hashMap[AppConstants.sortBySmallStr] =
          DropDownConstants.visibilityDropDownListWithNearMe[item.visibilityType] ?? '';
    }
    if (item.sortOrder != null || item.sortOrder?.isNotEmpty == true) {
      hashMap[AppConstants.sortBySmallStr] = AppConstants.priceOrderToOptions[item.sortOrder] ?? '';
    }
    if (item.dateCreated != null) {
      DateTime date = DateTimeUtils.instance.stringToDateInLocal(string: item.dateCreated!);
      hashMap[AppConstants.date] = DateTimeUtils.instance.dateOnlyWithSlash(date);
    }

    if (!item.location.isNullOrEmpty()) {
      hashMap[AppConstants.locationStr] = item.location!;
    }

    if (item.advanceSearch != null && item.advanceSearch?.isNotEmpty == true) {
      List<dynamic> jsonList = jsonDecode(item.advanceSearch!);

      List<AdvanceSearchItemMetaData> dataList =
          jsonList.map((item) => AdvanceSearchItemMetaData.fromJson(item)).toList();
      for (var element in dataList) {
        hashMap[element.controlLabel ?? ''] = element.displayValue ?? '';
      }
    }

    return hashMap;
  }

  static getCommaSeperatedData(List<DataModel>? dataModel) {
    var stringBuffer = StringBuffer();
    for (int i = 0; i < dataModel!.length; i++) {
      if (i == dataModel.length - 1) {
        var industryType = dataModel[i].name;
        stringBuffer.write(industryType);
      } else if (i <= dataModel.length - 3) {
        var industryType = dataModel[i].name;
        stringBuffer.write(industryType);
        stringBuffer.write(',');
      } else {
        var industryType = dataModel[i].name;
        stringBuffer.write(industryType);
        stringBuffer.write(' and ');
      }
    }
    return stringBuffer.toString();
  }

  static Future<bool> isWithinRadius(double targetLat, double targetLong, double radiusInMeters) async {
    try {
      var locationPermissionStatus = await Permission.location.status;

      if (locationPermissionStatus != PermissionStatus.granted) {
        await AppUtils.requestLocationPermission();
        return false; // Permissions not granted, unable to check.
      }

      var currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Calculate the distance between current location and target location
      double distanceInMeters = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        targetLat,
        targetLong,
      );

      // Check if the distance is within the specified radius
      return distanceInMeters <= radiusInMeters;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating radius: $e');
      }
      return false;
    }
  }

  static Future<String> convertFileToBase64(String filePath) async {
    try {
      // Load the file
      final file = File(filePath);

      // Read the file as bytes
      final bytes = await file.readAsBytes();

      // Encode bytes to Base64 string
      final base64String = base64Encode(bytes);

      return base64String;
    } catch (e) {
      // Handle errors (e.g., file not found)
      print('Error converting file to Base64: $e');
      return '';
    }
  }

  static Future<CategoriesListResponse?> getCategoryModelByCategoryName(String categoryName) async {
    var categoryList = await PreferenceHelper.instance.getCategoryList();
    CategoriesListResponse? category;
    // Find the categoryList ID matching the categoryList name
    if (categoryName == AddListingFormConstants.job) {
      category = categoryList.result?.firstWhere((item) => (item.formName == AddListingFormConstants.job),
          orElse: () => CategoriesListResponse(formId: 0, formName: ''));
    } else if (categoryName == AddListingFormConstants.realEstate ||
        categoryName == AddListingFormConstants.realEstateWithoutSpaceStr) {
      category = categoryList.result?.firstWhere((item) => item.formName == AddListingFormConstants.realEstate,
          orElse: () => CategoriesListResponse(formId: 0, formName: ''));
    } else {
      category = categoryList.result?.firstWhere((item) => item.formName == categoryName,
          orElse: () => CategoriesListResponse(formId: 0, formName: ''));
    }
    return category;
  }

  /// Parses and validates price values
  static double? parsePrice(dynamic price) {
    if (price == null || price == '' || price == '0.00') return null;
    final parsed = double.tryParse(price.toString());
    return parsed != null && parsed > 0 ? parsed : null;
  }

  /// Validates if the price is valid
  static bool isValidPrice(double? price) => price != null && price > 0;

  /// Formats the price based on its fractional value
  static String formatPrice(dynamic price) {
    final parsedPrice = parsePrice(price);
    if (isValidPrice(parsedPrice)) {
      if (parsedPrice! % 1 == 0) {
        // No decimal part (e.g., 46000000.00 becomes 46000000)
        return parsedPrice.toInt().toString();
      } else {
        // Retain decimal part (e.g., 45000000.05 remains 45000000.05)
        return parsedPrice.toString();
      }
    }
    return '';
  }

  static String formatInsightsNumbers(num value) {
    if (value % 1 == 0) {
      /// Remove decimal if it's a whole number
      return value.toInt().toString();
    } else {
      return value.toString().replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
  }
}
