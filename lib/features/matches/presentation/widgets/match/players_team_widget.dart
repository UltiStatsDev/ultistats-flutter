import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'player_avatar.dart';

class PlayersTeamWidget extends StatelessWidget {
  const PlayersTeamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Настройки размеров
    const double widgetHeight = 220; // Фиксированная высота прямоугольника
    const double avatarSize = 54;    // Размер каждой аватарки
    const double radius = 75;       // Радиус круга, по которому расставим игроков

    return LayoutBuilder(
      builder: (context, constraints) {
        // centerX будет динамическим в зависимости от ширины экрана
        final double centerX = constraints.maxWidth / 2;
        final double centerY = widgetHeight / 2;

        return Container(
          width: double.infinity, // На всю ширину
          height: widgetHeight,
          decoration: BoxDecoration(
            // Светлый контейнер из темы
            color: theme.colorScheme.primaryContainer,
            // Скругление углов как у обычных карточек
            borderRadius: BorderRadius.circular(theme.cardBorderRadius),
          ),
          child: Stack(
            children: List.generate(5, (index) {
              // Вычисляем угол для каждого из 5 игроков
              // -math.pi / 2 сдвигает начало на "12 часов"
              final double angle = index * (2 * math.pi / 5) - (math.pi / 2);

              // Координаты центра аватарки относительно центра контейнера
              final double x = centerX + radius * math.cos(angle);
              final double y = centerY + radius * math.sin(angle);

              return Positioned(
                // Сдвигаем на половину размера аватарки, чтобы (x, y) стал её центром
                left: x - (avatarSize / 2),
                top: y - (avatarSize / 2),
                child: PlayerAvatar(
                  photoUrl: null,
                  size: avatarSize,
                  hasDisk: index == 0,
                  label: "#12",
                ),
              );
            }),
          ),
        );
      },
    );
  }
}