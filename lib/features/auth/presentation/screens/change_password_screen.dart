import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/confirm_edit_button.dart';
import 'package:ultistats/core/widgets/form_tile.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/auth/domain/entities/auth_exception.dart';
import 'package:ultistats/features/auth/presentation/providers/auth_controller.dart';

/// Экран обязательной смены временного пароля.
///
/// Показывается корневым `AuthGate` без маршрута: пока пароль не сменён,
/// сервер не разрешает защищённые операции, и приложением пользоваться
/// всё равно нельзя.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  static const _minPasswordLength = 8;

  final _currentController = TextEditingController();
  final _newController = TextEditingController();

  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final currentPassword = _currentController.text;
    final newPassword = _newController.text;

    if (currentPassword.isEmpty) {
      setState(() => _error = 'Введите текущий пароль');
      return;
    }
    if (newPassword.length < _minPasswordLength) {
      setState(() => _error = 'Новый пароль должен быть не короче 8 символов');
      return;
    }
    if (newPassword == currentPassword) {
      setState(() => _error = 'Новый пароль должен отличаться от текущего');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      await ref
          .read(authControllerProvider.notifier)
          .changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          );
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Не удалось сменить пароль. Попробуйте ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _logout() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      await ref.read(authControllerProvider.notifier).logout();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ScreenWrapper(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text('Смена пароля', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Вы вошли с временным паролем. Придумайте новый пароль, '
                      'чтобы продолжить работу.',
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 24),
                    AutofillGroup(
                      child: Column(
                        children: [
                          FormTile(
                            controller: _currentController,
                            title: 'Текущий пароль:',
                            hint: 'Временный пароль',
                            obscureText: true,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.next,
                            enabled: !_isSubmitting,
                          ),
                          const SizedBox(height: 12),
                          FormTile(
                            controller: _newController,
                            title: 'Новый пароль:',
                            hint: 'Не короче 8 символов',
                            obscureText: true,
                            autofillHints: const [AutofillHints.newPassword],
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                            enabled: !_isSubmitting,
                          ),
                        ],
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (_isSubmitting)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.surface,
                          ),
                        ),
                      )
                    else
                      ConfirmEditButton(
                        confirmButtonText: 'Сменить пароль',
                        onTap: _submit,
                      ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: _isSubmitting ? null : _logout,
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.surface,
                        ),
                        child: const Text('Выйти из аккаунта'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
