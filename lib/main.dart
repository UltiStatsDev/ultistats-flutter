import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/app.dart';
import 'package:ultistats/run_api_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runFullApiTest();

  runApp(ProviderScope(child: App()));
}
