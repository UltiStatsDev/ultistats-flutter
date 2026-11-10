import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/auth/presentation/providers/auth_controller.dart';
import 'package:ultistats/features/auth/presentation/screens/change_password_screen.dart';

/// Накрывает приложение экраном смены пароля, пока сервер этого требует.
///
/// Экран рисуется поверх навигатора, а не вместо него: так не теряется
/// история маршрутов и после смены пароля пользователь возвращается туда, где
/// был.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).value;
    final mustChangePassword = session?.mustChangePassword ?? false;

    return Stack(
      fit: StackFit.expand,
      children: [child, if (mustChangePassword) const ChangePasswordScreen()],
    );
  }
}
