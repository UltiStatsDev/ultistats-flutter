import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/add_photo_widget.dart';
import 'package:ultistats/core/widgets/confirm_edit_button.dart';
import 'package:ultistats/core/widgets/form_tile.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/players/presentation/providers/players_providers.dart';
import 'package:ultistats/features/players/presentation/widgets/common/edit_player_app_bar.dart';
import 'package:ultistats/features/players/presentation/widgets/create_player/team_selector_tile.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';

@RoutePage()
class EditPlayerScreen extends ConsumerStatefulWidget {
  const EditPlayerScreen({
    super.key,
    required this.title,
    required this.confirmButtonText,
    this.editScreenInitial = const EditScreenInitial(),
  });

  final String title;
  final String confirmButtonText;
  final EditScreenInitial editScreenInitial;

  @override
  ConsumerState<EditPlayerScreen> createState() => _EditPlayerScreenState();
}

class _EditPlayerScreenState extends ConsumerState<EditPlayerScreen> {
  late final TextEditingController _nameTextController;
  late final TextEditingController _secondNameTextController;
  TeamListItem? _selectedTeam;
  File? _photo;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(
      text: widget.editScreenInitial.name,
    );
    _secondNameTextController = TextEditingController(
      text: widget.editScreenInitial.secondName,
    );
    _selectedTeam = widget.editScreenInitial.team;
    _photo = widget.editScreenInitial.photo;
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _secondNameTextController.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _nameTextController.text.trim();
    final secondName = _secondNameTextController.text.trim();

    if (name.isEmpty || secondName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заполните имя и фамилию')));
      return;
    }

    ref
        .read(editPlayerProvider.notifier)
        .savePlayer(
          firstName: name,
          lastName: secondName,
          teamId: _selectedTeam?.id,
          photo: _photo,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(editPlayerProvider, (previous, next) {
      if (next.isSuccess) {
        context.router.pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Игрок успешно сохранен')));
      }

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    final editState = ref.watch(editPlayerProvider);
    final isLoading = editState.isLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ScreenWrapper(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    EditPlayerAppBar(
                      title: widget.title,
                      onBackPressed: () {
                        context.router.pop();
                      },
                    ),
                    const SizedBox(height: 24),
                    AddPhotoWidget(
                      size: 200,
                      onImageSelected: (file) {
                        setState(() {
                          _photo = file;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    FormTile(
                      title: "Имя:",
                      hint: "Имя",
                      controller: _nameTextController,
                    ),
                    const SizedBox(height: 12),
                    FormTile(
                      title: "Фамилия:",
                      hint: "Фамилия",
                      controller: _secondNameTextController,
                    ),
                    const SizedBox(height: 12),
                    TeamSelectorTile(
                      initialTeam: _selectedTeam,
                      onTeamSelected: (team) {
                        setState(() {
                          _selectedTeam = team;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(),
              )
            else
              ConfirmEditButton(
                confirmButtonText: widget.confirmButtonText,
                onTap: _onSave,
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class EditScreenInitial {
  final String? name;
  final String? secondName;
  final TeamListItem? team;
  final File? photo;

  const EditScreenInitial({this.name, this.secondName, this.team, this.photo});
}
