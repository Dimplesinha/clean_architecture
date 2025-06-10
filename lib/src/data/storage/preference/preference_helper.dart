import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03-09-2024
/// @Message : [PreferenceHelper]
///
/// Used for storing value, fetching the stored value and clearing the values at time of logout and deleting account
class PreferenceHelper {
  static const String prefUserModel = 'user_model';
  static const String prefCategoryModel = 'category_model';
  static const String prefCountryModel = 'country_model';
  static const String prefPremiumListingModel = 'premium_listing_model';

  static final PreferenceHelper _singleton = PreferenceHelper._internal();

  PreferenceHelper._internal();

  SharedPreferences? sharedPreferences;

  static PreferenceHelper get instance => _singleton;

  static String isLogin = 'is_login';
  static const String fcmToken = 'fcm_token';

  /// loading, data, error

  Future<SharedPreferences> getSharedPrefs() async {
    return sharedPreferences ??= await SharedPreferences.getInstance();
  }

  ///can be used for storing values with bool, int, double, string or object
  Future<void> setPreference({required String key, required dynamic value}) async {
    var sp = await getSharedPrefs();

    switch (value.runtimeType) {
      case bool:
        await sp.setBool(key, value);
        break;
      case int:
        await sp.setInt(key, value);
        break;
      case double:
        await sp.setDouble(key, value);
        break;
      case String:
        await sp.setString(key, value);
        break;
      case Object:
        String customObjectJson = jsonEncode(value);
        sp.setString(key, customObjectJson);
        break;
      default:
        await sp.setString(key, value);
        break;
    }
  }

  ///can be used for getting values with bool, int, double, string or object
  Future<dynamic> getPreference({required String key, dynamic type}) async {
    var sp = await getSharedPrefs();

    switch (type) {
      case bool:
        return sp.getBool(key) ?? false;
      case int:
        return sp.getInt(key) ?? 0;
      case double:
        return sp.getDouble(key) ?? 0.0;
      case String:
        return sp.getString(key) ?? '';
      case Object:
        String? customObjectJson = sp.getString(key);
        var result = '';
        if (customObjectJson != null) {
          result = jsonDecode(customObjectJson);
        }
        return result;
      default:
        return sp.getString(key) ?? '';
    }
  }

  ///specifically used for storing user login details.
  Future<void> setUser(LoginResponse? loginResponse) async {
    var sp = await getSharedPrefs();
    try {
      String user = jsonEncode(loginResponse?.toJson());
      AppUtils.loginUserModel = loginResponse?.result;
      await sp.setString(PreferenceHelper.prefUserModel, user);
    } catch (e) {
      if (kDebugMode) {
        print('---$this $e');
      }
    }
  }

  Future<void> updateEmail(
    String newEmail,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the current user data from SharedPreferences
    String? userJson = prefs.getString(PreferenceHelper.prefUserModel);

    try {
      if (userJson != null) {
        LoginResponse loginResponse = LoginResponse.fromJson(json.decode(userJson));

        loginResponse.result?.email = newEmail;
        await prefs.setString(PreferenceHelper.prefUserModel, json.encode(loginResponse.toJson()));
      }
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
  }

  Future<void> updateData(bool isPasswordAvailable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the current user data from SharedPreferences
    String? userJson = prefs.getString(PreferenceHelper.prefUserModel);

    try {
      if (userJson != null) {
        LoginResponse loginResponse = LoginResponse.fromJson(json.decode(userJson));
        loginResponse.result?.isPasswordAvailable = isPasswordAvailable;
        await prefs.setString(PreferenceHelper.prefUserModel, json.encode(loginResponse.toJson()));
      }
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
  }

  Future<void> updateProfile(String profilePic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the current user data from SharedPreferences
    String? userJson = prefs.getString(PreferenceHelper.prefUserModel);

    try {
      if (userJson != null) {
        LoginResponse loginResponse = LoginResponse.fromJson(json.decode(userJson));
        loginResponse.result?.profilepic = profilePic;

        await prefs.setString(PreferenceHelper.prefUserModel, json.encode(loginResponse.toJson()));
      }
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
  }

  Future<void> rememberMe(bool rememberMe, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the current user data from SharedPreferences
    String? userJson = prefs.getString(PreferenceHelper.prefUserModel);

    try {
      if (userJson != null) {
        LoginResponse loginResponse = LoginResponse.fromJson(json.decode(userJson));

        loginResponse.result?.rememberMeEnabled = rememberMe;
        loginResponse.result?.password = password;
        await prefs.setString(PreferenceHelper.prefUserModel, json.encode(loginResponse.toJson()));
      }
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
  }

  ///specifically used for getting user details to display info.
  Future<LoginResponse> getUserData() async {
    var sp = await getSharedPrefs();
    String user = sp.getString(PreferenceHelper.prefUserModel) ?? '';
    LoginResponse loginResponse = LoginResponse();
    try {
      if (user.isEmpty) {
        return loginResponse;
      }
      Map<String, dynamic> json = jsonDecode(user);
      loginResponse = LoginResponse.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
    return loginResponse;
  }

  ///specifically used for storing category list.
  Future<void> setCategoryData(CategoriesList? allListingModel) async {
    var sp = await getSharedPrefs();
    try {
      sharedPreferences?.remove(PreferenceHelper.prefCategoryModel);
      String categoryList = jsonEncode(allListingModel?.toJson());
      // Store the JSON string in SharedPreferences
      await sp.setString(PreferenceHelper.prefCategoryModel, categoryList);
    } catch (e) {
      if (kDebugMode) {
        print('---$this $e');
      }
    }
  }

  ///specifically used for getting category list to display in add listing and category bottom sheet.
  Future<CategoriesList> getCategoryList() async {
    var sp = await getSharedPrefs();
    String category = sp.getString(PreferenceHelper.prefCategoryModel) ?? '';
    CategoriesList categoryList = CategoriesList();
    try {
      if (category.isEmpty) {
        return categoryList;
      }
      Map<String, dynamic> json = jsonDecode(category);
      categoryList = CategoriesList.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
    return categoryList;
  }

  ///specifically used for storing country list.
  Future<void> setCountryList(CountryAllListing? countryAllListing) async {
    var sp = await getSharedPrefs();
    try {
      sharedPreferences?.remove(PreferenceHelper.prefCountryModel);
      String countryList = jsonEncode(countryAllListing?.toJson());
      // Store the JSON string in SharedPreferences
      await sp.setString(PreferenceHelper.prefCountryModel, countryList);
    } catch (e) {
      if (kDebugMode) {
        print('---$this $e');
      }
    }
  }

  ///specifically used for getting country list to display on signup and profile screen.
  Future<CountryAllListing> getCountryList() async {
    var sp = await getSharedPrefs();
    String country = sp.getString(PreferenceHelper.prefCountryModel) ?? '';
    CountryAllListing countryList = CountryAllListing();
    try {
      if (country.isEmpty) {
        return countryList;
      }
      Map<String, dynamic> json = jsonDecode(country);
      countryList = CountryAllListing.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
    return countryList;
  }

  ///for clearing and setting value of isLogin to false when logout is done or account is deleted.
  Future<void> clearUserPreference() async {
    await setPreference(key: PreferenceHelper.isLogin, value: false);
    // await sharedPreferences?.clear();
  }

  ///used for clearing user data from preference.
  Future<void> clearUserData() async {
    await sharedPreferences?.remove(prefUserModel);
    // await sharedPreferences?.clear();
  }

  Future<void> deleteUserData() async {
    await setPreference(key: PreferenceHelper.isLogin, value: false);
    await sharedPreferences?.remove(prefUserModel);
    await sharedPreferences?.clear();
  }

  Future<void> clearUserLogData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the current user data
    String? userJson = prefs.getString(PreferenceHelper.prefUserModel);

    // Variables to store email and password
    String? savedEmail;
    String? savedPassword;
    bool rememberMe = false;
    if (userJson != null) {
      try {
        // Parse the current user data
        LoginResponse loginResponse = LoginResponse.fromJson(json.decode(userJson));

        // Check if "Remember Me" is enabled
        rememberMe = loginResponse.result?.rememberMeEnabled ?? false;

        // Save email and password if rememberMe is true
        if (rememberMe) {
          savedEmail = loginResponse.result?.email;
          savedPassword = loginResponse.result?.password;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing user data: $e');
        }
      }
    }

    // Clear all data
    await prefs.clear();

    // If rememberMe is true, restore email and password
    if (rememberMe && (savedEmail != null || savedPassword != null)) {
      LoginResponse loginResponse = LoginResponse(
        result: LoginModel(
          email: savedEmail,
          password: savedPassword,
          rememberMeEnabled: true,
        ),
      );

      // Save the updated data back to SharedPreferences
      await prefs.setString(PreferenceHelper.prefUserModel, json.encode(loginResponse.toJson()));
    } else {
      // Remove the entire user data if rememberMe is false
      await clearUserData();
    }
  }

  Future<void> updatedUserData(LoginModel? updatedUserData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the current user data from SharedPreferences
    String? userJson = prefs.getString(PreferenceHelper.prefUserModel);

    try {
      if (userJson != null) {
        LoginResponse loginResponse = LoginResponse.fromJson(json.decode(userJson));

        loginResponse.result?.firstName = updatedUserData?.firstName ?? '';
        loginResponse.result?.lastName = updatedUserData?.lastName ?? '';
        loginResponse.result?.gender = updatedUserData?.gender ?? '';
        loginResponse.result?.birthYear = updatedUserData?.birthYear ?? 0;
        loginResponse.result?.phoneNumber = updatedUserData?.phoneNumber ?? '';
        loginResponse.result?.address = updatedUserData?.address ?? '';
        loginResponse.result?.accountTypeValue = updatedUserData?.accountTypeValue ?? '';
        loginResponse.result?.accountType = updatedUserData?.accountType ;
        loginResponse.result?.location =updatedUserData?.location ?? '' ;
        loginResponse.result?.pushNotification = updatedUserData?.pushNotification ?? false;
        loginResponse.result?.email = updatedUserData?.email ?? '';
        loginResponse.result?.emailNotification = updatedUserData?.emailNotification ?? false;
        loginResponse.result?.phoneCountryCode = updatedUserData?.phoneCountryCode ?? '';
        loginResponse.result?.phoneDialCode = updatedUserData?.phoneDialCode ?? '';
        loginResponse.result?.profilepic = updatedUserData?.profilepic ?? '';
        AppUtils.loginUserModel?.accountType = updatedUserData?.accountType ;

        await prefs.setString(PreferenceHelper.prefUserModel, json.encode(loginResponse.toJson()));
      }
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
  }

  Future<void> updateAccountType(String accountType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the current user data from SharedPreferences
    String? userJson = prefs.getString(PreferenceHelper.prefUserModel);

    try {
      if (userJson != null) {
        LoginResponse loginResponse = LoginResponse.fromJson(json.decode(userJson));

        loginResponse.result?.accountTypeValue = accountType;
        AppUtils.loginUserModel?.accountTypeValue = accountType;
        await prefs.setString(PreferenceHelper.prefUserModel, json.encode(loginResponse.toJson()));
      }
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
  }


  ///specifically used for storing Premium ListingModel list.
  Future<void> setPremiumListingData(MyListingResponse? allListingModel) async {
    var sp = await getSharedPrefs();
    try {
      sharedPreferences?.remove(PreferenceHelper.prefPremiumListingModel);
      String categoryList = jsonEncode(allListingModel?.toJson());
      // Store the JSON string in SharedPreferences
      await sp.setString(PreferenceHelper.prefPremiumListingModel, categoryList);
    } catch (e) {
      if (kDebugMode) {
        print('---$this $e');
      }
    }
  }

  ///specifically used for getting Premium ListingModel list.
  Future<MyListingResponse> getPremiumListingData() async {
    var sp = await getSharedPrefs();
    String response = sp.getString(PreferenceHelper.prefPremiumListingModel) ?? '';
    MyListingResponse myListingResponse = MyListingResponse();
    try {
      if (response.isEmpty) {
        return myListingResponse;
      }
      Map<String, dynamic> json = jsonDecode(response);
      myListingResponse = MyListingResponse.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print('----$this $e');
      }
    }
    return myListingResponse;
  }
}
