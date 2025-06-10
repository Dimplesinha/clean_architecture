import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/domain/api/interceptors/auth_interceptor.dart';
import 'package:workapp/src/domain/domain_exports.dart';
///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 08/11/23
/// @Message :
/// [ApiRepository]
class ApiRepository{
  static final ApiRepository _singleton = ApiRepository._internal();
  ApiRepository._internal();
  static ApiRepository get instance => _singleton;

  /// Init All Services
  Future<void> initAllServices() async{
    await configureDio();
    var apiClientConfigured = await configureApiClient(hasLogInterceptor: true, hasAuthInterceptor: false);
    ConsoleLogger.instance.print(apiClientConfigured);
  }

  /// Configure Dio
  Future<void> configureDio() async{
    ApiClient.instance.dio.options.baseUrl = ApiConstant.baseUrl;
    ApiClient.instance.dio.options.connectTimeout = const Duration(milliseconds: 30000);
    ApiClient.instance.dio.options.responseType = ResponseType.json;
    ApiClient.instance.dio.options.contentType = ContentType.json.toString();
  }

  /// Configure API Client
  Future<String> configureApiClient({bool hasLogInterceptor = false, bool hasAuthInterceptor = false}) {
    final apiClientFuture = Completer<String>();
    if(hasLogInterceptor){
      final logInterceptor = LogInterceptor(requestBody: true, responseBody: true);
      ApiClient.instance.dio.interceptors.add(logInterceptor);
    }
    if(hasAuthInterceptor){
      final authInterceptor = AuthInterceptor();
      ApiClient.instance.dio.interceptors.add(authInterceptor);
    }
    apiClientFuture.complete('API client Initialized!');
    return apiClientFuture.future;
  }
}