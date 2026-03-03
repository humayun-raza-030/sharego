import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class ProfileService {
  ProfileService(this._dio);

  final Dio _dio;

  /// GET /users/me — current user profile.
  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/users/me');
    return (response.data as Map).cast<String, dynamic>();
  }

  /// PATCH /users/me — update profile fields.
  Future<Map<String, dynamic>> updateMe({
    String? name,
    String? phone,
    String? city,
    String? country,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (city != null) data['city'] = city;
    if (country != null) data['country'] = country;
    final response = await _dio.patch('/users/me', data: data);
    return (response.data as Map).cast<String, dynamic>();
  }

  /// POST /kyc/submit — submit KYC documents.
  Future<Map<String, dynamic>> submitKyc({
    required String docType,
    required String docUrl,
    String? selfieUrl,
    String? passportUrl,
  }) async {
    final response = await _dio.post('/kyc/submit', data: {
      'doc_type': docType,
      'doc_url': docUrl,
      if (selfieUrl != null) 'selfie_url': selfieUrl,
      if (passportUrl != null) 'passport_url': passportUrl,
    });
    return (response.data as Map).cast<String, dynamic>();
  }

  /// GET /kyc/status — check KYC status.
  Future<Map<String, dynamic>> getKycStatus() async {
    final response = await _dio.get('/kyc/status');
    return (response.data as Map).cast<String, dynamic>();
  }

  /// POST /media/upload — upload a file (image) from path.
  Future<Map<String, dynamic>> uploadMedia(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post('/media/upload', data: formData);
    return (response.data as Map).cast<String, dynamic>();
  }

  /// POST /media/upload — upload from pre-read bytes (avoids stale cache paths).
  /// Writes bytes to a temp file then uses the proven fromFile path.
  Future<Map<String, dynamic>> uploadMediaBytes(Uint8List bytes, String filename) async {
    final tempFile = File('${Directory.systemTemp.path}/sharego_$filename');
    await tempFile.writeAsBytes(bytes);
    try {
      return await uploadMedia(tempFile.path);
    } finally {
      try { await tempFile.delete(); } catch (_) {}
    }
  }

  /// POST /reviews — submit a review.
  Future<Map<String, dynamic>> submitReview({
    required String targetType,
    required int targetId,
    required int revieweeId,
    required int rating,
    String? comment,
  }) async {
    final response = await _dio.post('/reviews', data: {
      'target_type': targetType,
      'target_id': targetId,
      'reviewee_id': revieweeId,
      'rating': rating,
      if (comment != null) 'comment': comment,
    });
    return (response.data as Map).cast<String, dynamic>();
  }

  /// GET /reviews — list reviews for a user.
  Future<List<Map<String, dynamic>>> getReviews({int? revieweeId}) async {
    final response = await _dio.get('/reviews', queryParameters: {
      if (revieweeId != null) 'reviewee_id': revieweeId,
    });
    final list = response.data as List;
    return list.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }
}
