import 'package:dio/dio.dart';

class AuthService {
  AuthService(this._dio);

  final Dio _dio;

  Future<String> requestOtp(String email, {String? phone}) async {
    try {
      final resp = await _dio.post('/auth/register', data: {
        'email': email,
        if (phone != null) 'phone': phone,
      });
      final data = resp.data as Map<String, dynamic>;
      // In dev, otp_dev may be returned for convenience
      return data['otp_dev']?.toString() ?? '';
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<String> verifyOtp(String email, String otp) async {
    try {
      final resp = await _dio.post('/auth/verify-otp', data: {
        'email': email,
        'otp': otp,
      });
      final data = resp.data as Map<String, dynamic>;
      return data['access_token'] as String;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Exception _mapError(DioException e) {
    if (e.response != null) {
      final status = e.response?.statusCode ?? 0;
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['detail']?.toString() ?? e.message)
          : e.message;
      return Exception('HTTP $status: $msg');
    }
    return Exception(e.message);
  }
}
