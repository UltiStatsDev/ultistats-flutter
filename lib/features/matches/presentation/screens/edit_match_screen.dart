import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/confirm_edit_button.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/matches/presentation/providers/edit_match/edit_match_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/edit_match/edit_match_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/edit_match/edit_match_app_bar.dart';
import 'package:ultistats/features/matches/presentation/widgets/edit_match/team_selector_tile.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';

@RoutePage()
class EditMatchScreen extends ConsumerStatefulWidget {
  const EditMatchScreen({
    super.key,
    required this.title,
    required this.confirmButtonText,
    this.initialData = const EditMatchScreenInitial(),
  });

  final String title;
  final String confirmButtonText;
  final EditMatchScreenInitial initialData;

  @override
  ConsumerState<EditMatchScreen> createState() => _EditMatchScreenState();
}

class _EditMatchScreenState extends ConsumerState<EditMatchScreen> {
  TeamListItem? _team1;
  TeamListItem? _team2;
  DateTime? _plannedStartTime;

  bool get canDelete => widget.initialData.id != null;

  @override
  void initState() {
    super.initState();
    _team1 = widget.initialData.team1;
    _team2 = widget.initialData.team2;
    _plannedStartTime = widget.initialData.plannedStartTime;
  }

  void _onDelete() {
    if (canDelete) {
      ref
          .read(editMatchProvider.notifier)
          .deleteMatch(id: widget.initialData.id!);
    }
  }

  void _onSave() {
    if (_team1 == null || _team2 == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите две команды')),
      );
      return;
    }

    if (_plannedStartTime == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите дату и время')),
      );
      return;
    }

    ref
        .read(editMatchProvider.notifier)
        .saveMatch(
      matchId: widget.initialData.id,
      teamIds: [_team1!.id, _team2!.id],
      plannedStartTime: _plannedStartTime,
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _plannedStartTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_plannedStartTime ?? DateTime.now()),
    );

    if (time == null) return;

    setState(() {
      _plannedStartTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    ref.listen(editMatchProvider, (previous, next) {
      if (next is EditMatchSaved) {
        context.router.pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Матч успешно сохранен')));
      }

      if (next is EditMatchDeleted) {
        context.router.popUntilRoot();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Матч успешно удален')));
      }

      if (next is EditMatchError) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Произошла ошибка"),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    final editState = ref.watch(editMatchProvider);
    final isLoading = editState is EditMatchLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ScreenWrapper(
        child: Column(
          children: [
            EditMatchAppBar(
              title: widget.title,
              onBackPressed: () {
                context.router.pop();
              },
              onDeletePressed: canDelete ? _onDelete : null,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TeamSelectorTile(
                      label: "Первая команда:",
                      initialTeam: _team1,
                      excludedIds: _team2 != null ? {_team2!.id} : {},
                      onTeamSelected: (team) => setState(() => _team1 = team),
                    ),
                    const SizedBox(height: 24),
                    TeamSelectorTile(
                      label: "Вторая команда:",
                      initialTeam: _team2,
                      excludedIds: _team1 != null ? {_team1!.id} : {},
                      onTeamSelected: (team) => setState(() => _team2 = team),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Планируемое начало:",
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickDateTime,
                      borderRadius: BorderRadius.circular(
                        theme.textFieldBorderRadius,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: theme.textFieldHeight,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            theme.textFieldBorderRadius,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: theme.primaryColor.withValues(alpha: 0.5),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _plannedStartTime != null
                                  ? dateFormat.format(_plannedStartTime!)
                                  : "Выберите дату и время",
                              style: _plannedStartTime != null
                                  ? theme.textFieldStyleText
                                  : theme.inputDecorationTheme.hintStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(),
              )
            else
              ConfirmEditButton(
                confirmButtonText: widget.confirmButtonText,
                onTap:
                (_team1 != null &&
                    _team2 != null &&
                    _plannedStartTime != null)
                    ? _onSave
                    : null,
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class EditMatchScreenInitial {
  final String? id;
  final TeamListItem? team1;
  final TeamListItem? team2;
  final DateTime? plannedStartTime;

  const EditMatchScreenInitial({
    this.id,
    this.team1,
    this.team2,
    this.plannedStartTime,
  });
}
