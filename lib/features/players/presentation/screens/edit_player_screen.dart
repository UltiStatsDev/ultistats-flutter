import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/add_photo_widget.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/core/widgets/form_tile.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/players/presentation/widgets/common/edit_player_app_bar.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';

@RoutePage()
class EditPlayerScreen extends StatefulWidget {
  const EditPlayerScreen({
    super.key,
    required this.title,
    required this.confirmButtonText,
    required this.editScreenInitial,
  });

  final String title;
  final String confirmButtonText;
  final EditScreenInitial editScreenInitial;

  @override
  State<EditPlayerScreen> createState() => _EditPlayerScreenState();
}

class _EditPlayerScreenState extends State<EditPlayerScreen> {
  final _nameTextController = TextEditingController();
  final _secondNameTextController = TextEditingController();
  final _teamTextController = TextEditingController();
  File? _photo;

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _secondNameTextController.dispose();
    _teamTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenWrapper(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EditPlayerAppBar(
                    title: widget.title,
                    onBackPressed: () {
                      context.router.pop();
                    },
                  ),
                  AddPhotoWidget(
                    size: 200,
                    onImageSelected: (file) {
                      setState(() {
                        _photo = file;
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  FormTile(
                    title: "Имя:",
                    hint: "Имя",
                    controller: _nameTextController,
                  ),
                  SizedBox(height: 12),
                  FormTile(
                    title: "Фамилия:",
                    hint: "Фамилия",
                    controller: _secondNameTextController,
                  ),
                  SizedBox(height: 12),
                  // TODO сделать чтобы оно разворачивалось и велся поиск
                  FormTile(
                    title: "Команда:",
                    hint: "Нет команды",
                    controller: _teamTextController,
                  ),
                ],
              ),
            ),
          ),

          AppInkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(theme.cardBorderRadius),
            child: Ink(
              height: theme.textFieldHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  theme.textFieldBorderRadius,
                ),
                color: theme.colorScheme.primaryContainer,
              ),
              child: Center(
                child: Text(
                  widget.confirmButtonText,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class EditScreenInitial {
  final String? name;
  final String? secondName;
  final TeamDetail? team;
  final File? photo;

  const EditScreenInitial({this.name, this.secondName, this.team, this.photo});
}
