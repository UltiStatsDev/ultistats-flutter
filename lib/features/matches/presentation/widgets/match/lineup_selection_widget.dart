import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/matches/presentation/providers/game/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/game/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/common/player_select_card.dart';
import 'package:ultistats/features/players/domain/entities/team_player.dart';

class LineupSelectionWidget extends ConsumerWidget {
  const LineupSelectionWidget({super.key, required this.state});

  final GameStateLineupSelection state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(matchGameProvider(state.match).notifier);

    final team1 = state.match.teams[0];
    final team2 = state.match.teams[1];

    final isBothLineupsReady =
        state.team1SelectedIds.length == 5 && state.team2SelectedIds.length == 5;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Выберите составы (5 на 5)",
            style: theme.textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: theme.screenPadding),
            child: Column(
              children: [
                _buildTeamLineup(
                  context: context,
                  team: team1,
                  selectedIds: state.team1SelectedIds,
                  teamIndex: 0,
                  notifier: notifier,
                  isBothReady: isBothLineupsReady,
                ),
                const SizedBox(height: 16),
                _buildTeamLineup(
                  context: context,
                  team: team2,
                  selectedIds: state.team2SelectedIds,
                  teamIndex: 1,
                  notifier: notifier,
                  isBothReady: isBothLineupsReady,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamLineup({
    required BuildContext context,
    required MatchTeam team,
    required Set<String> selectedIds,
    required int teamIndex,
    required MatchGameNotifier notifier,
    required bool isBothReady,
  }) {
    final theme = Theme.of(context);
    final isCountValid = selectedIds.length == 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                team.name,
                style: theme.textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isCountValid
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${selectedIds.length} / 5",
                style: theme.textTheme.displayMedium?.copyWith(
                  color: isCountValid ? Colors.greenAccent : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: team.participants.length - 2, /// Костыль чтобы не отображались последние 2 игрока
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 110,
            mainAxisExtent: 100,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final participant = team.participants[index];
            final isSelected = selectedIds.contains(participant.participantId);

            return PlayerSelectCard(
              player: _mapParticipantToTeamPlayer(participant, team.id),
              isSelected: isSelected,
              onTap: () => notifier.togglePlayer(participant.participantId, teamIndex),
            );
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isBothReady
                ? () => notifier.confirmLineupAndStartPull(team.id)
                : null,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text("ПОДТВЕРДИТЬ И ПУЛ"),
          ),
        ),
      ],
    );
  }

  TeamPlayer _mapParticipantToTeamPlayer(MatchParticipant p, String teamId) {
    return TeamPlayer(
      teamId: teamId,
      playerId: p.participantId,
      firstName: p.firstName ?? p.displayName,
      lastName: p.lastName ?? "",
      number: p.number,
    );
  }
}
