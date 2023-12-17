import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:poca/providers/preference_provider.dart';

class DioInterceptor extends Interceptor {
  DioInterceptor(this.dio);
  final Dio dio;
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await PreferenceProvider.instance.getString('access_token');
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint(token);
    }
    options.headers['Content-Type']= 'application/json';
    super.onRequest(options, handler);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403 ||
        err.response?.statusCode == 401) {
      debugPrint('111111');
      var res = await refreshToken();
      if(res) {
        handler.resolve(await _retry(err.requestOptions));
        return;
      }
    }

    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    final refreshToken = await PreferenceProvider.instance.getString('refresh_token');
    if(refreshToken.isEmpty) return false;

   try {
     final response = await dio.post('/auth/refresh-token', data: {'token': refreshToken});
     debugPrint('rftoken: $refreshToken');
     debugPrint('=>>>>>>>>>>>>> ${response.statusCode.toString()}');
     if (response.statusCode == 200) {
       debugPrint('=>>>>>>>>>>>>>accessToken ${response.data['accessToken']}');
       await PreferenceProvider.instance.setString('access_token' , response.data['accessToken']);
       return true;
     } else {
       await PreferenceProvider.instance.removeJsonToPref('access_token');
       return false;
     }
   }
   catch( err) {
     debugPrint('$err');
     return false;
   }
  }}
