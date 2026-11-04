import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ultistats/core/config/env.dart';

/// Уровень логирования приложения.
enum AppLogLevel { debug, info, warning, error }

/// Единая точка логирования: пишет в консоль (в debug) и отправляет события
/// в Sentry, если он инициализирован.
///
/// Если [error] передан, уровень по умолчанию считается [AppLogLevel.error]
/// и событие уходит в Sentry как исключение. Обычные сообщения попадают в
/// Sentry как логи. Уровень [AppLogLevel.debug] остаётся только в консоли,
/// чтобы отладочные сообщения не тратили квоту Sentry.
///
/// Примеры:
/// ```dart
/// log("Match started", name: runtimeType.toString());
/// log("Error while _loadMatch", error: e, stackTrace: st,
///     name: runtimeType.toString());
/// ```
void log(
  String message, {
  Object? error,
  StackTrace? stackTrace,
  String? name,
  AppLogLevel? level,
}) {
  final logLevel =
      level ?? (error == null ? AppLogLevel.info : AppLogLevel.error);
  final loggerName = name ?? 'app';

  // Один вывод в консоль: print/debugPrint видны и в `flutter run`, и в
  // Android logcat, и в `flutter test`. developer.log здесь не используем,
  // иначе одно и то же сообщение печатается дважды.
  if (kDebugMode) {
    final buffer = StringBuffer()
      ..write('[${logLevel.name.toUpperCase()}] [$loggerName] $message');
    if (error != null) buffer.write('\n$error');
    if (stackTrace != null) buffer.write('\n$stackTrace');
    debugPrint(buffer.toString());
  }

  // До инициализации Sentry (или без DSN) остаёмся только локальными логами.
  if (!Sentry.isEnabled) return;

  // Debug-логи нужны только локально.
  if (logLevel == AppLogLevel.debug) return;

  if (error != null && logLevel == AppLogLevel.error) {
    unawaited(
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.level = _sentryLevel(logLevel);
          scope.setContexts('log', {'logger': loggerName, 'message': message});
        },
      ),
    );
    return;
  }

  final body = error == null ? message : '$message: $error';
  final attributes = {'logger': SentryAttribute.string(loggerName)};

  switch (logLevel) {
    case AppLogLevel.debug:
      // Уже отфильтровано выше.
      break;
    case AppLogLevel.info:
      Sentry.logger.info(body, attributes: attributes);
      break;
    case AppLogLevel.warning:
      Sentry.logger.warn(body, attributes: attributes);
      break;
    case AppLogLevel.error:
      Sentry.logger.error(body, attributes: attributes);
      break;
  }
}

/// Инициализирует Sentry, если DSN задан через `--dart-define`.
///
/// Без DSN Sentry не включается, и [log] пишет только локально.
Future<void> initLogging() async {
  if (Env.sentryDsn.isEmpty) {
    log("SENTRY_DSN is not set, logs stay local", name: "AppLogger");
    return;
  }

  await SentryFlutter.init((options) {
    options
      ..dsn = Env.sentryDsn
      ..environment = appFlavor ?? 'dev'
      ..attachStacktrace = true
      ..enableLogs = true
      ..tracesSampleRate = 0
      ..debug = false;
  });

  log("Sentry initialized", name: "AppLogger");
}

SentryLevel _sentryLevel(AppLogLevel level) => switch (level) {
  AppLogLevel.debug => SentryLevel.debug,
  AppLogLevel.info => SentryLevel.info,
  AppLogLevel.warning => SentryLevel.warning,
  AppLogLevel.error => SentryLevel.error,
};
