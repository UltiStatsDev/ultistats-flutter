import 'package:flutter/material.dart';
import 'package:ultistats/core/config/config.dart';

class PlayerAvatar extends StatelessWidget {
  final String? photoUrl;
  final double size;
  final bool hasDisk;
  final String? label; // Новое поле для подписи

  const PlayerAvatar({
    super.key,
    required this.photoUrl,
    required this.size,
    this.hasDisk = false,
    this.label,
  });

  String? get _fullUrl =>
      photoUrl != null ? '${AppConfig.photoServerUrl}$photoUrl' : null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surfaceContainerHigh,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _fullUrl != null
                    ? Image.network(
                  _fullUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildLoading(theme);
                  },
                )
                    : _buildPlaceholder(theme),
              ),
              if (hasDisk)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _DiskIndicator(size: 20),
                ),
            ],
          ),
        ),
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Icon(
      Icons.person,
      size: size * 0.6,
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
    );
  }

  Widget _buildLoading(ThemeData theme) {
    return Center(
      child: SizedBox(
        width: size * 0.4,
        height: size * 0.4,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.primaryColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

/// Красный кружок-индикатор владения диском
class _DiskIndicator extends StatelessWidget {
  final double size;

  const _DiskIndicator({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}