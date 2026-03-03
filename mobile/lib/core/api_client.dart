import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import '../config/env.dart';
import 'auth_interceptor.dart';
import 'auth_storage.dart';

Dio buildDio(EnvConfig config, AuthStorage storage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(AuthInterceptor(() => storage.loadToken()));

  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      retries: 3,
      retryDelays: const [
        Duration(milliseconds: 400),
        Duration(milliseconds: 800),
        Duration(milliseconds: 1600),
      ],
      logPrint: config.enableLogging ? print : null,
    ),
  );

  return dio;
}
