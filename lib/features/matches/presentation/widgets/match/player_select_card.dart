import 'package:flutter/material.dart';
import 'package:ultistats/core/config/config.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/players/domain/entities/team_player.dart';

class PlayerSelectCard extends StatelessWidget {
  const PlayerSelectCard({
    super.key,
    required this.player,
    required this.isSelected,
    required this.onTap,
  });

  final TeamPlayer player;
  final bool isSelected;
  final VoidCallback onTap;

  String? get _fullUrl => player.photoUrl != null 
      ? "${AppConfig.photoServerUrl}${player.photoUrl!}" 
      : null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(theme.cardBorderRadius),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAvatar(theme),
            const SizedBox(height: 4),
            Text(
              player.firstName,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "#${player.number ?? '?'}",
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    const double size = 54;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.avatarBackgroundColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: _fullUrl != null
          ? Image.network(
              _fullUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            )
          : _buildPlaceholder(theme),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Center(
      child: Icon(
        Icons.person,
        color: theme.avatarIconColor,
        size: 28,
      ),
    );
  }
}
