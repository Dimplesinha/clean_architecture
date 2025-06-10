import 'dart:convert';
import 'dart:io';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_dynamic_form.dart';
import 'package:workapp/src/domain/models/error_response_model.dart';
import 'package:workapp/src/utils/network_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 24-09-2024
/// [ApiClient]
class ApiClient {
  static final ApiClient _apiClient = ApiClient._internal();

  ApiClient._internal();

  static ApiClient get instance => _apiClient;

  /// Dio
  final Dio dio = Dio();

  /// GET API without token in header
  Future<ResponseWrapper> getApi(
      {required String path, Map<String, String>? queryParameters, String? customBaseUrl}) async {
    try {
      bool isConnected = await NetworkUtils.instance.isConnected();
      if (!isConnected) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      //dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
      Response response = await dio.get('${customBaseUrl ?? ApiConstant.baseUrl}$path', queryParameters: queryParameters);
      if (response.data != null) {
        return ResponseWrapper(status: true, message: response.statusMessage ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      }else {
        return ResponseWrapper(status: false, message: response.statusMessage ?? ApiConstant.emptyStr, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
       if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      }else{
         return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);}
    }
  }

  /// POST API without token in header
  Future<ResponseWrapper> postApi(
      {required String path,
      Map<String, dynamic>? requestBody,
      bool? isBodyInArray,
      Map<String, String>? queryParameters}) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.post(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }
  /// POST API with array without token in header
  Future<ResponseWrapper> postApiWithArray({
    required String path,
    List<Map<String, dynamic>>? requestBody,
    Map<String, String>? queryParameters,
  }) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.interceptors.add(DioInterceptor());
      //_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.post(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }
  /// PATCH API
  Future<ResponseWrapper> patchApi(
      {required String path,
      required Map<String, dynamic> requestBody,
      bool? isBodyInArray,
      Map<String, String>? queryParameters}) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      //_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.patch(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 400) {
        // Parse the error response using ErrorResponseModel
        ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(response.data);

        // Check if there are validation errors in the result
        String message;
        if (errorResponseModel.validationErrors != null && errorResponseModel.validationErrors!.isNotEmpty) {
          // Collect all validation error messages
          message = errorResponseModel.validationErrors!.map((error) => error.errorMessage).join(', ');
        } else {
          // Use the message from the response or a default error message
          message = errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong;
        }

        return ResponseWrapper(
          status: false,
          message: message,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }

  /// PUT API without token in header
  Future<ResponseWrapper> putApi(
      {required String path,
      Map<String, dynamic>? requestBody,
      bool? isBodyInArray,
      Map<String, String>? queryParameters}) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      //_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.put(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        // Parse the error response using ErrorResponseModel
        ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(response.data);

        // Check if there are validation errors in the result
        String message;
        if (errorResponseModel.validationErrors != null && errorResponseModel.validationErrors!.isNotEmpty) {
          // Collect all validation error messages
          message = errorResponseModel.validationErrors!.map((error) => error.errorMessage).join(', ');
        } else {
          // Use the message from the response or a default error message
          message = errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong;
        }

        return ResponseWrapper(
          status: false,
          message: message,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);

      if (e.response?.statusCode == 400) {
        // Check if there are validation errors
        String message;
        if (errorResponseModel.validationErrors != null && errorResponseModel.validationErrors!.isNotEmpty) {
          // Join all error messages from validationErrors
          message = errorResponseModel.validationErrors!.map((error) => error.errorMessage).join(', ');
        } else {
          // Use the main message if no validation errors are present
          message = errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong;
        }

        return ResponseWrapper(
          status: false,
          message: message,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }

  ///Post api with token in header
  Future<ResponseWrapper> postApiWithToken({
    required String path,
    Map<String, dynamic>? requestBody,
    bool? isBodyInArray,
    Map<String, String>? queryParameters,
    required String userToken,
  }) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers.remove('content-length');
      dio.interceptors.add(DioInterceptor());
      //dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.post(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }


  ///Post api with token in header
  Future<ResponseWrapper> postJSONApiWithToken({
    required String path,
    AddListingDynamicForm? requestBody,
    bool? isBodyInArray,
    Map<String, String>? queryParameters,
    required String userToken,
  }) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }

      // REMOVE content-length before making request
      dio.options.headers.remove('content-length');

      dio.interceptors.add(DioInterceptor());
      //dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));

      Response response = await dio.post(
        '${ApiConstant.baseUrl}$path',
        data: jsonEncode(requestBody), // Ensure proper JSON encoding
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ResponseWrapper(status: true, message: response.data['message'] ?? ApiConstant.successStr, responseData: response.data);
      } else {
        return ResponseWrapper(status: false, message: response.data['message'] ?? AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      return ResponseWrapper(
        status: false,
        message: e.response?.data['message'] ?? e.message.toString(),
        responseData: null,
      );
    }
  }

  /// PUT/ Update API with token in header
  Future<ResponseWrapper> putApiWithToken({
    required String path,
    Map<String, dynamic>? requestBody,
    bool? isBodyInArray,
    Map<String, String>? queryParameters,
    required String userToken,
  }) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      //_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.put(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }

  /// Delete API with token in header
  Future<ResponseWrapper> deleteApiWithToken({
    required String path,
    Map<String, dynamic>? requestBody,
    bool? isBodyInArray,
    Map<String, String>? queryParameters,
    required String userToken,
  }) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      //_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.delete(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }

  Future<ResponseWrapper> getApiWithTokenRequest({
    required String path,
    Map<String, dynamic>? requestBody,
    bool? isBodyInArray,
    Map<String, String>? queryParameters,
    required String userToken,
  }) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      //_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.get(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }

  /// POST API without token in header
  Future<ResponseWrapper> contactUsApi(
      {required String path,
      Map<String, dynamic>? requestBody,
      bool? isBodyInArray,
      Map<String, String>? queryParameters}) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      //_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.post(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }

  /// PUT API for link account
  Future<ResponseWrapper> linkAccountPutApi(
      {required String path,
      Map<String, dynamic>? requestBody,
      bool? isBodyInArray,
      Map<String, String>? queryParameters}) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      //_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.put(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        // Parse the error response using ErrorResponseModel
        ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(response.data);

        // Check if there are validation errors in the result
        String message;
        if (errorResponseModel.validationErrors != null && errorResponseModel.validationErrors!.isNotEmpty) {
          // Collect all validation error messages
          message = errorResponseModel.validationErrors!.map((error) => error.errorMessage).join(', ');
        } else {
          // Use the message from the response or a default error message
          message = errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong;
        }

        return ResponseWrapper(
          status: false,
          message: message,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);

      if (e.response?.statusCode == 400) {
        // Check if there are validation errors
        String message;
        if (errorResponseModel.validationErrors != null && errorResponseModel.validationErrors!.isNotEmpty) {
          // Join all error messages from validationErrors
          message = errorResponseModel.validationErrors!.map((error) => error.errorMessage).join(', ');
        } else {
          // Use the main message if no validation errors are present
          message = errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong;
        }

        return ResponseWrapper(
          status: false,
          message: message,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }

  /// POST API for advance search.
  Future<ResponseWrapper> advanceSearchApi(
      {required String path,
      Map<String, dynamic>? requestBody,
      bool? isBodyInArray,
      Map<String, String>? queryParameters}) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      /*_dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));*/
      Response response = await dio.post(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }

  /// Delete API used for delete search record.
  Future<ResponseWrapper> deleteSearchApi({
    required String path,
    Map<String, dynamic>? requestBody,
    bool? isBodyInArray,
    Map<String, String>? queryParameters,
    required String userToken,
  }) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.options.headers['content-length'] = null;
      dio.interceptors.add(DioInterceptor());
      // dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));
      Response response = await dio.delete(
        '${ApiConstant.baseUrl}$path',
        data: (isBodyInArray ?? false) ? jsonEncode([requestBody]) : jsonEncode(requestBody),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(
            status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }
  Future<ResponseWrapper> uploadFile({
    required String path,
    Map<String, dynamic>? requestBody,
    bool? isBodyInArray,
    Map<String, String>? queryParameters,
    required String userToken,
    required File file,
  }) async {
    try {
      if (!await NetworkUtils.instance.isConnected()) {
        return ResponseWrapper(status: false, message: AppConstants.internetNotAvailableStr, responseData: null);
      }
      dio.interceptors.add(DioInterceptor());
      // dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: false));

      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "File": await MultipartFile.fromFile(file.path, filename: fileName),
        ...?requestBody,
      });

      Response response = await dio.post(
        '${ApiConstant.baseUrl}$path',
        queryParameters: queryParameters,
        data: formData,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        String? msg = response.data['message'];
        return ResponseWrapper(status: true, message: msg ?? ApiConstant.successStr, responseData: response.data);
      } else if (response.statusCode == 306) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 400) {
        ErrorResponseModel errorResponseModel = response.data;
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? response.statusMessage ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (response.statusCode == 500) {
        return ResponseWrapper(
          status: false,
          message: response.data['message'] ?? AppConstants.serverErrorStr,
          responseData: null,
        );
      } else {
        return ResponseWrapper(status: false, message: AppConstants.somethingWentWrong, responseData: null);
      }
    } on DioException catch (e) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(e.response?.data);
      if (e.response?.statusCode == 400) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.result ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 306) {
        return ResponseWrapper(
          status: false,
          message: errorResponseModel.message ?? e.response?.data['message'] ?? AppConstants.somethingWentWrong,
          responseData: null,
        );
      } else if (e.response?.statusCode == 500) {
        return ResponseWrapper(status: false, message: e.response?.data['message'] ?? AppConstants.serverErrorStr, responseData: null);
      } else if (e.response?.statusCode == 401) {
        return ResponseWrapper(status: false, message: AppConstants.sessionErrorStr, responseData: null);
      } else {
        return ResponseWrapper(status: false, message: e.message.toString(), responseData: null);
      }
    }
  }
}

