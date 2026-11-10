import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/auth/presentation/providers/auth_controller.dart';

/// Сообщает контроллеру аутентификации о реальных действиях пользователя,
/// чтобы тот мог продлить сессию (не чаще раза в минуту).
class AuthActivityListener extends ConsumerWidget {
  const AuthActivityListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        ref.read(authControllerProvider.notifier).noteActivity();
      },
      child: child,
    );
  }
}
