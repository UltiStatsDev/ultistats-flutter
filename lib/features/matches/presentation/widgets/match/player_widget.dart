import 'package:flutter/material.dart';
import 'package:ultistats/core/config/config.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/player_avatar.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({
    super.key,
    required this.photoUrl,
    this.hasDisk = false,
    this.size = 60,
    this.onTap,
  });

  final String? photoUrl;
  final bool hasDisk;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            // Аватарка игрока в круге
            PlayerAvatar(size: 100, photoUrl: "asd"),

            // Индикатор диска (красный кружок)
            if (hasDisk)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
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


