import 'package:dio/dio.dart';

class WalletService {
  WalletService(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getWallet({int limit = 20, int offset = 0}) async {
    final response = await _dio.get(
      '/users/me/wallet',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return (response.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> topUp(double amount) async {
    final response = await _dio.post(
      '/users/me/wallet/topup',
      data: {'amount': amount},
    );
    return (response.data as Map).cast<String, dynamic>();
  }
}
