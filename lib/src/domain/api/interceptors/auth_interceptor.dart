import 'package:dio/dio.dart';
import 'package:workapp/src/domain/domain_exports.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 08/11/23
/// @Message : [AuthInterceptor]
///
class AuthInterceptor implements InterceptorsWrapper{
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ConsoleLogger.instance.print('${err.message}');
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ConsoleLogger.instance.print(options.path);
    return handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    ConsoleLogger.instance.print('${response.statusCode}');
    return handler.next(response);
  }

}