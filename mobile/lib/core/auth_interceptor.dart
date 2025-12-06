import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._getToken);

  final Future<String?> Function() _getToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // let caller handle sign-out; just forward
    }
    super.onError(err, handler);
  }
}
