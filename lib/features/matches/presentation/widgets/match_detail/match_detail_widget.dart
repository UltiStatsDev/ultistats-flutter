import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail_state.dart';
import 'package:ultistats/features/matches/presentation/screens/edit_match_screen.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_detail/match_detail_app_bar.dart';
import 'package:ultistats/router/app_router.gr.dart';

class MatchDetailWidget extends ConsumerWidget {
  const MatchDetailWidget({super.key, required this.state});

  final MatchDetailLoaded state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final match = state.match;
    final dateFormat = DateFormat('dd MMMM, HH:mm');

    return Column(
      children: [
        MatchDetailAppBar(
          onBackPressed: () => context.router.pop(),
          onEditPressed: () {
            context.router.push(
              EditMatchRoute(
                title: "редактирование",
                confirmButtonText: "Сохранить",
                initialData: EditMatchScreenInitial(
                  id: match.id,
                  team1: match.teams[0].toListItem(),
                  team2: match.teams[1].toListItem(),
                  plannedStartTime: match.plannedStartTimestamp,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildScoreboard(context),
        const SizedBox(height: 32),

        _buildInfoSection(
          context,
          title: "Статус",
          value: _statusToString(match.status),
        ),
        if (match.plannedStartTimestamp != null)
          _buildInfoSection(
            context,
            title: "Запланировано",
            value: dateFormat.format(match.plannedStartTimestamp!),
          ),
        if (match.startedAt != null)
          _buildInfoSection(
            context,
            title: "Начало",
            value: dateFormat.format(match.startedAt!),
          ),
        if (match.endedAt != null)
          _buildInfoSection(
            context,
            title: "Завершение",
            value: dateFormat.format(match.endedAt!),
          ),

        Spacer(),

        if (match.status == MatchStatus.planned)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: state.isStarting
                  ? null
                  : () => ref
                        .read(matchDetailProvider(match.id).notifier)
                        .startMatch(),
              icon: state.isStarting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.play_arrow_rounded),
              label: const Text("Начать матч"),
            ),
          ),

        if (match.status == MatchStatus.inProgress)
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.router.push(const MatchRoute()),
              child: const Text("К игровому полю"),
            ),
          ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildScoreboard(BuildContext context) {
    final theme = Theme.of(context);
    final team1 = state.match.teams[0];
    final team2 = state.match.teams[1];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(theme.cardBorderRadius),
        boxShadow: theme.cardBoxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTeamInfo(context, team1),
          Column(
            children: [
              Text(
                state.match.status == MatchStatus.planned
                    ? "- : -"
                    : "${team1.score} : ${team2.score}",
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          _buildTeamInfo(context, team2),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(BuildContext context, dynamic team) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          PhotoWidget(photoUrl: team.photoUrl, size: 60),
          const SizedBox(height: 8),
          Text(
            team.name,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: theme.textTheme.displayMedium),
          Text(
            value,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _statusToString(MatchStatus status) {
    return switch (status) {
      MatchStatus.planned => "Запланирован",
      MatchStatus.inProgress => "В процессе",
      MatchStatus.finished => "Завершен",
    };
  }
}
