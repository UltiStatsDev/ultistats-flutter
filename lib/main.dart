import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultistats/app.dart';
import 'package:ultistats/core/config/app_storage.dart';
import 'package:ultistats/core/logging/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLogging();

  if (!kIsWeb) {
    try {
      AppStorage.supportDirectory =
          (await getApplicationSupportDirectory()).path;
    } catch (error, stackTrace) {
      log(
        'Failed to resolve application support directory',
        error: error,
        stackTrace: stackTrace,
        name: 'AppStorage',
        level: AppLogLevel.warning,
      );
    }
  }

  runApp(ProviderScope(child: App()));
}
