import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/confirm_edit_button.dart';
import 'package:ultistats/core/widgets/form_tile.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/auth/domain/entities/auth_exception.dart';
import 'package:ultistats/features/auth/presentation/providers/auth_controller.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final login = _loginController.text.trim();
    final password = _passwordController.text;

    if (login.isEmpty || password.isEmpty) {
      setState(() => _error = 'Введите логин и пароль');
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
          .login(login: login, password: password);
      if (!mounted) return;
      // Если сервер требует сменить пароль, корневой AuthGate покажет
      // соответствующий экран поверх приложения.
      context.router.maybePop();
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Не удалось войти. Попробуйте ещё раз.');
      }
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
            SizedBox(
              height: theme.appBarHeight,
              child: Row(
                children: [
                  IconButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => context.router.maybePop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text('Вход', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Войдите, чтобы создавать, изменять и удалять данные.',
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 24),
                    AutofillGroup(
                      child: Column(
                        children: [
                          FormTile(
                            controller: _loginController,
                            title: 'Логин:',
                            hint: 'Логин',
                            autofillHints: const [AutofillHints.username],
                            textInputAction: TextInputAction.next,
                            enabled: !_isSubmitting,
                          ),
                          const SizedBox(height: 12),
                          FormTile(
                            controller: _passwordController,
                            title: 'Пароль:',
                            hint: 'Пароль',
                            obscureText: true,
                            autofillHints: const [AutofillHints.password],
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
                        confirmButtonText: 'Войти',
                        onTap: _submit,
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
