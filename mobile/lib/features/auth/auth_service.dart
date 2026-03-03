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

  Future<String> forgotPassword(String email) async {
    try {
      final resp = await _dio.post('/auth/forgot', data: {
        'email': email,
      });
      final data = resp.data as Map<String, dynamic>;
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

  Future<String> loginWithPassword(String email, String password) async {
    try {
      final resp = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = resp.data as Map<String, dynamic>;
      return data['access_token'] as String;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<String> registerWithPassword(String email, String password, {String? phone}) async {
    try {
      final resp = await _dio.post('/auth/register-password', data: {
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      });
      final data = resp.data as Map<String, dynamic>;
      return data['access_token'] as String;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<String> signInWithGoogle(String idToken) async {
    try {
      final resp = await _dio.post('/auth/google', data: {
        'id_token': idToken,
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
      String? msg;
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        if (data['error'] is Map<String, dynamic>) {
          msg = (data['error'] as Map<String, dynamic>)['message']?.toString();
        }
        msg ??= data['detail']?.toString();
      }
      msg ??= e.message;
      return Exception('HTTP $status: $msg');
    }
    return Exception(e.message);
  }
}
