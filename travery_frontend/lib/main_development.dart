import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:app_links/app_links.dart';

import 'package:travery_frontend/config/dependencies.dart';
import 'package:travery_frontend/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;

  final appLinks = AppLinks();

  runApp(MultiProvider(providers: providers, child: const MyApp()));

  // Deep links được xử lý bởi GoRouter redirect trong app_router.dart
  // Chỉ log deep links để debug nếu cần
  try {
    final initialUri = await appLinks.getInitialLink();
    if (initialUri != null) {
      Logger.root.info('Main: Cold start with deep link: $initialUri');
    }
  } catch (e) {
    Logger.root.warning('Main: Failed to get initial URI: $e');
  }

  appLinks.uriLinkStream.listen((uri) {
    Logger.root.info('Main: Received deep link from stream: $uri');
  });
}
