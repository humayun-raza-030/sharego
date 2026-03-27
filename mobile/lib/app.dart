import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'core/providers.dart';
import 'router/app_router.dart';

class ShareGoApp extends ConsumerWidget {
  const ShareGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'ShareGo',
      theme: AppTheme.theme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
