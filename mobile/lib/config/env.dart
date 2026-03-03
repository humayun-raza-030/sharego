import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  final String apiBaseUrlDev;
  final String apiBaseUrlStage;
  final String apiBaseUrlProd;

  /// Active API base URL (uses dev URL, which is the default for all environments).
  String get apiBaseUrl => apiBaseUrlDev;
  final bool enableLogging;
  final bool enableOfflineQueue;
  final bool enableAiChat;
  final String defaultCurrency;
  final String defaultTimezone;

  EnvConfig._({
    required this.apiBaseUrlDev,
    required this.apiBaseUrlStage,
    required this.apiBaseUrlProd,
    required this.enableLogging,
    required this.enableOfflineQueue,
    required this.enableAiChat,
    required this.defaultCurrency,
    required this.defaultTimezone,
  });

  factory EnvConfig.load() {
    final devUrl = dotenv.get('API_BASE_URL_DEV', fallback: 'http://localhost:8000');
    final stageUrl = dotenv.get('API_BASE_URL_STAGE', fallback: devUrl);
    final prodUrl = dotenv.get('API_BASE_URL_PROD', fallback: devUrl);

    return EnvConfig._(
      apiBaseUrlDev: devUrl,
      apiBaseUrlStage: stageUrl,
      apiBaseUrlProd: prodUrl,
      enableLogging: dotenv.get('ENABLE_LOGGING', fallback: 'true') == 'true',
      enableOfflineQueue: dotenv.get('ENABLE_OFFLINE_QUEUE', fallback: 'true') == 'true',
      enableAiChat: dotenv.get('ENABLE_AI_CHAT', fallback: 'true') == 'true',
      defaultCurrency: dotenv.get('DEFAULT_CURRENCY', fallback: 'PKR'),
      defaultTimezone: dotenv.get('DEFAULT_TIMEZONE', fallback: 'Asia/Karachi'),
    );
  }
}
