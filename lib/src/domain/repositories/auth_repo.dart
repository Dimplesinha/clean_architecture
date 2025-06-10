import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/core/routes/routing.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/utils/app_utils.dart';
import 'package:workapp/src/utils/network_utils.dart';

class AuthRepository {
  static final AuthRepository _singleton = AuthRepository._internal();

  AuthRepository._internal();

  static AuthRepository get instance => _singleton;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  ///Login Api call using ApiClient with postApi call using ResponseWrapper and adding response to login response model.
  Future<ResponseWrapper<LoginResponse>> login(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.login, requestBody: json);
      if (response.status) {
        LoginResponse model = LoginResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      }
      else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper> logout() async {
    try {
      bool isConnected = await NetworkUtils.instance.isConnected();
      if (!isConnected) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr);
      }
      await PreferenceHelper.instance.clearUserPreference();
      await PreferenceHelper.instance.clearUserLogData( );
      await SignInWithLinkedIn.logout();
      AppUtils.loginUserModel = null;
      await Future.delayed(const Duration(seconds: 2));
      return ResponseWrapper(status: true, message: AppConstants.successStr);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  Future<ResponseWrapper> deleteAccount() async {
    try {
      bool isConnected = await NetworkUtils.instance.isConnected();
      if (!isConnected) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr);
      }
      var response = await ApiClient.instance.deleteSearchApi(
          path: '${ApiConstant.deleteAccount}${AppUtils.loginUserModel?.uuid}',
          userToken: AppUtils.loginUserModel?.token ?? '');
      if(response.status ) {
        await PreferenceHelper.instance.deleteUserData();
        AppUtils.loginUserModel = null;
        return ResponseWrapper(status: true, message: response.message);
      }
      else{
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  ///login with facebook and authentication code.
  ///facebook permission added when logIn is called.
  ///switch case added for all the possible results.
  ///for success login status we will able to access accessToken and user credential using userCred.user,
  /// by adding .user u can have access of all the user login data for example added print statement for printing
  /// emailId of user loggedIn.
  Future<ResponseWrapper> signInWithFB() async {
    try {
      bool isConnected = await NetworkUtils.instance.isConnected();
      if (!isConnected) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr);
      }

      FacebookLogin facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(permissions: [
        FacebookPermission.email,
        FacebookPermission.publicProfile,
      ]);

      switch (result.status) {
        case FacebookLoginStatus.success:
          final token = result.accessToken?.token;

          final cred = FacebookAuthProvider.credential(token ?? '');
          final userCred = await FirebaseAuth.instance.signInWithCredential(cred);

          if (kDebugMode) {
            print('${userCred.user?.email}');
          }

          AppUtils.showErrorSnackBar(AppConstants.loginSuccessfullyStr);
          AppRouter.pushRemoveUntil(AppRoutes.homeScreenRoute);
          return ResponseWrapper(status: true, message: AppConstants.loginSuccessfullyStr);
        case FacebookLoginStatus.cancel:
          if (kDebugMode) {
            print('Login cancelled by user.');
          }
          AppUtils.showErrorSnackBar(AppConstants.loginCancelStr);
          return ResponseWrapper(status: false, message: AppConstants.loginCancelStr);
        case FacebookLoginStatus.error:
          if (kDebugMode) {
            print('Error logging in: ${result.error}');
          }
          AppUtils.showErrorSnackBar('${result.error}');
          return ResponseWrapper(status: false, message: '${result.error}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('---->>Error: ${e.toString()}');
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }

  ///SignUp Api call using ApiClient with postApi call using ResponseWrapper and adding response to signUp response model.

  Future<ResponseWrapper<LoginResponse>> signUp(Map<String, dynamic> json) async {
    try {
      var response = await ApiClient.instance.postApi(path: ApiConstant.signUp, requestBody: json);
      if (response.status) {
        LoginResponse model = LoginResponse.fromJson(response.responseData);
        return ResponseWrapper(status: true, message: response.message, responseData: model);
      } else {
        return ResponseWrapper(status: false, message: response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong);
    }
  }
}
