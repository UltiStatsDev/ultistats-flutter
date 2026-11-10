import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/auth/domain/entities/account.dart';
import 'package:ultistats/features/auth/domain/entities/auth_session.dart';
import 'package:ultistats/features/auth/presentation/providers/auth_controller.dart';
import 'package:ultistats/router/app_router.gr.dart';

@RoutePage()
class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);
    try {
      await ref.read(authControllerProvider.notifier).logout();
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  void _login() {
    // Открываем вход поверх bottom navigation: после успешного входа
    // LoginScreen сам закроется и вернёт пользователя на эту вкладку.
    context.router.root.push(const LoginRoute());
  }

  void _retry() {
    ref.read(authControllerProvider.notifier).retryRestore();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);

    return ScreenWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: theme.appBarHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Аккаунт', style: theme.textTheme.titleMedium),
            ),
          ),
          Expanded(child: SingleChildScrollView(child: _content(theme, auth))),
        ],
      ),
    );
  }

  Widget _content(ThemeData theme, AsyncValue<AuthSession> auth) {
    if (auth.isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.surface),
        ),
      );
    }

    final session = auth.value;
    if (session == null) {
      return _AccountPanel(
        icon: Icons.cloud_off,
        title: 'Не удалось проверить сессию',
        message: 'Проверьте подключение к сети и попробуйте ещё раз.',
        actionText: 'Повторить',
        onAction: _retry,
      );
    }

    final account = session.account;
    if (!session.isAuthenticated || account == null) {
      return _AccountPanel(
        icon: Icons.person_outline,
        title: 'Вы не вошли в аккаунт',
        message:
            'Просмотр матчей, команд и игроков доступен без входа. '
            'Войдите, чтобы создавать и изменять данные.',
        actionText: 'Войти',
        onAction: _login,
      );
    }

    return _AccountDetails(
      account: account,
      canWriteSports: session.canWriteSports,
      isLoggingOut: _isLoggingOut,
      onLogout: _logout,
    );
  }
}

/// Белая карточка с иконкой, пояснением и одним действием.
class _AccountPanel extends StatelessWidget {
  const _AccountPanel({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionText,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(theme.cardBorderRadius),
        boxShadow: theme.cardBoxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.primaryColor, size: 36),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: theme.textFieldHeight,
            child: FilledButton(onPressed: onAction, child: Text(actionText)),
          ),
        ],
      ),
    );
  }
}

/// Карточка вошедшего пользователя с данными аккаунта и выходом.
class _AccountDetails extends StatelessWidget {
  const _AccountDetails({
    required this.account,
    required this.canWriteSports,
    required this.isLoggingOut,
    required this.onLogout,
  });

  final Account account;
  final bool canWriteSports;
  final bool isLoggingOut;
  final VoidCallback onLogout;

  String get _displayName {
    final name = account.displayName.trim();
    return name.isEmpty ? 'Пользователь' : name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(theme.cardBorderRadius),
            boxShadow: theme.cardBoxShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.primaryColor.withValues(alpha: 0.12),
                    child: Text(
                      _displayName.characters.first.toUpperCase(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_displayName, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 2),
                        Text(account.login, style: theme.textTheme.labelMedium),
                        const SizedBox(height: 6),
                        _RoleBadge(role: account.role),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                height: 1,
                color: theme.primaryColor.withValues(alpha: 0.1),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    canWriteSports ? Icons.edit_outlined : Icons.visibility,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      canWriteSports
                          ? 'Доступно редактирование данных'
                          : 'Доступен только просмотр данных',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: theme.textFieldHeight,
          child: FilledButton(
            onPressed: isLoggingOut ? null : onLogout,
            child: isLoggingOut
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.surface,
                    ),
                  )
                : const Text('Выйти'),
          ),
        ),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final AccountRole role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
