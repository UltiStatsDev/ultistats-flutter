import 'package:flutter/material.dart';
import 'package:ultistats/core/data/config.dart';

class TeamPhoto extends StatelessWidget {
  final String? photoUrl;
  final double size;
  final double borderRadius;

  const TeamPhoto({
    super.key,
    required this.photoUrl,
    required this.size,
    this.borderRadius = 6,
  });

  String? get _fullUrl =>
      photoUrl != null ? '${AppConfig.baseUrl}$photoUrl' : null;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: _fullUrl != null
            ? Image.network(
                _fullUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoading(context);
                },
              )
            : _buildPlaceholder(context),
      ),
    );
  }

  //TODO сделать фотку плейсхолдер нормальную
  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.groups_outlined,
        size: size * 0.5,
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
