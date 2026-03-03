import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'config/env.dart';
import 'core/airline_repository.dart';
import 'core/airport_repository.dart';
import 'core/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final config = EnvConfig.load();

  final airportRepo = AirportRepository();
  await airportRepo.load();

  final airlineRepo = AirlineRepository();
  await airlineRepo.load();

  runApp(
    ProviderScope(
      overrides: [
        envConfigProvider.overrideWithValue(config),
        airportRepositoryProvider.overrideWithValue(airportRepo),
        airlineRepositoryProvider.overrideWithValue(airlineRepo),
      ],
      child: const ShareGoApp(),
    ),
  );
}
