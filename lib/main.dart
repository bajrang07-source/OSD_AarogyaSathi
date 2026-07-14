import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/db/database_service.dart';
import 'data/local_db/database_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for consistent UX on rural devices
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize local database
  await DatabaseService.instance.initialize();

  // Seed real data (idempotent — skips if already seeded)
  await DatabaseSeeder.instance.seedAll();

  runApp(
    const ProviderScope(
      child: ArogyaSathiApp(),
    ),
  );
}
