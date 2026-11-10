import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/features/auth/domain/entities/auth_session.dart';
import 'package:ultistats/features/auth/presentation/providers/auth_controller.dart';
import 'package:ultistats/router/app_router.gr.dart';

class AccountButton extends ConsumerWidget {
  const AccountButton({super.key});

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final shouldLogin = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Theme.of(context).cardBorderRadius),
        ),
      ),
      builder: (_) => const _AccountSheet(),
    );

    if (shouldLogin == true && context.mounted) {
      await context.router.push(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final session = auth.value;
    final isLoading = auth.isLoading;

    return AppInkWell(
      onTap: isLoading ? null : () => _onTap(context, ref),
      borderRadius: BorderRadius.circular(theme.searchBarBorderRadius),
      child: Ink(
        width: theme.searchBarSize,
        height: theme.searchBarSize,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(theme.searchBarBorderRadius),
        ),
        child: Center(
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.primaryColor,
                  ),
                )
              : Icon(
                  session?.isAuthenticated ?? false
                      ? Icons.person
                      : Icons.person_outline,
                  color: theme.primaryColor,
                  size: 30,
                ),
        ),
      ),
    );
  }
}

class _AccountSheet extends ConsumerStatefulWidget {
  const _AccountSheet();

  @override
  ConsumerState<_AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends ConsumerState<_AccountSheet> {
  bool _isBusy = false;

  Future<void> _logout() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      await ref.read(authControllerProvider.notifier).logout();
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
        Navigator.of(context).maybePop();
      }
    }
  }

  void _retry() {
    ref.read(authControllerProvider.notifier).retryRestore();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final session = auth.value;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(theme.screenPadding),
        child: _content(context, theme, auth, session),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    ThemeData theme,
    AsyncValue<AuthSession> auth,
    AuthSession? session,
  ) {
    if (auth.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: theme.primaryColor),
        ),
      );
    }

    if (session == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Аккаунт', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            'Не удалось проверить сессию.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _SheetButton(text: 'Повторить', onPressed: _retry),
        ],
      );
    }

    if (!session.isAuthenticated && !session.mustChangePassword) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Аккаунт', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            'Войдите, чтобы создавать, изменять и удалять данные.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _SheetButton(
            text: 'Войти',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    }

    final account = session.account;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Аккаунт', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(
          account?.displayName ?? 'Пользователь',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          [
            if (account != null) account.login,
            if (account != null) account.role.label,
          ].join(' • '),
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        _SheetButton(text: 'Выйти', onPressed: _isBusy ? null : _logout),
      ],
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: theme.textFieldHeight,
      width: double.infinity,
      child: FilledButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
