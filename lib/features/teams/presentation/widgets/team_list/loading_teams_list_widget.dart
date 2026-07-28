import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class LoadingTeamsListWidget extends StatelessWidget {
  const LoadingTeamsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Skeletonizer.zone(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Bone(
                  height: theme.searchBarSize,
                  borderRadius: BorderRadius.circular(
                    theme.searchBarBorderRadius,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Bone(
                width: theme.searchBarSize,
                height: theme.searchBarSize,
                borderRadius: BorderRadius.circular(
                  theme.searchBarBorderRadius,
                ),
              ),
              SizedBox(width: 8),
              Bone(
                width: theme.searchBarSize,
                height: theme.searchBarSize,
                borderRadius: BorderRadius.circular(
                  theme.searchBarBorderRadius,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: theme.screenPadding, top: 5),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Bone(
                  height: theme.cardHeight,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(theme.cardBorderRadius),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          ),
        ],
      ),
    );
  }
}
