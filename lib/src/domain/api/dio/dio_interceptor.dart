import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/data/storage/preference/preference_helper.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/repositories/auth_repo.dart';

class DioInterceptor extends Interceptor {
  DioInterceptor();

  bool kEnableLog = false;
  bool _isLoggingOut = false; // Flag to indicate if logout is in progress

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      if ((err.response?.statusCode == 401 || err.response?.statusCode == 403) && !_isLoggingOut) {
        _isLoggingOut = true; // Set flag to true to prevent further API calls

        // Call to the logout API
        var response = await AuthRepository.instance.logout();

        // navigatorKey.currentState?.pop();
        // AppUtils.showSnackBar(response.message, SnackBarType.success);

        if (response.status) {
          // Navigate to sign-in screen and remove all other routes
          AppRouter.pushRemoveUntil(AppRoutes.signInViewRoute);
        }

        _isLoggingOut = false; // Reset flag after logout and redirection
      } else {
        handler.next(err); // Pass the error to the next interceptor
      }
    } catch (e) {
      if (kDebugMode) print('DioInterceptor.onError--$e');
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data == null) {}
    super.onResponse(response, handler);
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      /// passing User Access token here
      PreferenceHelper preferenceHelper = PreferenceHelper.instance;
      LoginResponse userModel = await preferenceHelper.getUserData();
      if (userModel.result?.token?.isNotEmpty ?? false) {
        options.headers.addAll({'Authorization': 'Bearer ${userModel.result?.token}'});
      }
      if (kEnableLog) {
        log(
          'error log request ',
          error: '${userModel.result?.token} ${options.uri.path}\n ${options.data} \n ${options.queryParameters}',
        );
      }
    } catch (ex) {
      /// Error Message
    }
    super.onRequest(options, handler);
  }
}
