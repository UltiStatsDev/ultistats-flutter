import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/app.dart';
import 'package:ultistats/core/logging/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLogging();

  runApp(ProviderScope(child: App()));
}
