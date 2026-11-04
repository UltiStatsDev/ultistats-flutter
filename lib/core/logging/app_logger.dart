import 'dart:async';
import 'dart:developer' as developer;

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
/// Sentry как логи.
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

  // Консоль / DevTools.
  developer.log(
    message,
    name: loggerName,
    level: _developerLevel(logLevel),
    error: error,
    stackTrace: stackTrace,
  );

  if (kDebugMode) {
    final buffer = StringBuffer()
      ..write('[${logLevel.name.toUpperCase()}] [$loggerName] $message');
    if (error != null) buffer.write('\n$error');
    debugPrint(buffer.toString());
    if (stackTrace != null) debugPrint('$stackTrace');
  }

  // До инициализации Sentry (или без DSN) остаёмся только локальными логами.
  if (!Sentry.isEnabled) return;

  if (error != null) {
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

  final attributes = {'logger': SentryAttribute.string(loggerName)};

  switch (logLevel) {
    case AppLogLevel.debug:
      Sentry.logger.debug(message, attributes: attributes);
    case AppLogLevel.info:
      Sentry.logger.info(message, attributes: attributes);
    case AppLogLevel.warning:
      Sentry.logger.warn(message, attributes: attributes);
    case AppLogLevel.error:
      Sentry.logger.error(message, attributes: attributes);
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

int _developerLevel(AppLogLevel level) => switch (level) {
  AppLogLevel.debug => 500,
  AppLogLevel.info => 800,
  AppLogLevel.warning => 900,
  AppLogLevel.error => 1000,
};

SentryLevel _sentryLevel(AppLogLevel level) => switch (level) {
  AppLogLevel.debug => SentryLevel.debug,
  AppLogLevel.info => SentryLevel.info,
  AppLogLevel.warning => SentryLevel.warning,
  AppLogLevel.error => SentryLevel.error,
};
