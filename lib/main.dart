import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/app.dart';
import 'package:ultistats/run_api_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Запуск API тестов
  await runFullApiTest();

  runApp(ProviderScope(child: App()));
}
