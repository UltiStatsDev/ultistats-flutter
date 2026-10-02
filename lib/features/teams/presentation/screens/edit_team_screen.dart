import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/add_photo_widget.dart';
import 'package:ultistats/core/widgets/confirm_edit_button.dart';
import 'package:ultistats/core/widgets/form_tile.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/teams/presentation/providers/edit_team/edit_team_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/edit_team/edit_team_state.dart';
import 'package:ultistats/features/teams/presentation/widgets/edit_team/edit_team_app_bar.dart';

@RoutePage()
class EditTeamScreen extends ConsumerStatefulWidget {
  const EditTeamScreen({
    super.key,
    required this.title,
    required this.confirmButtonText,
    this.initialData = const EditTeamScreenInitial(),
  });

  final String title;
  final String confirmButtonText;
  final EditTeamScreenInitial initialData;

  @override
  ConsumerState<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends ConsumerState<EditTeamScreen> {
  late final TextEditingController _nameTextController;
  late final TextEditingController _cityTextController;
  File? _photo;

  bool get canDelete => widget.initialData.id != null;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(text: widget.initialData.name);
    _cityTextController = TextEditingController(text: widget.initialData.city);
    _photo = widget.initialData.photo;
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _cityTextController.dispose();
    super.dispose();
  }

  void _onImageDelete() {
    if (canDelete) {
      ref.read(editTeamProvider.notifier).deletePhoto(widget.initialData.id!);
    }
  }

  void _onDelete() {
    if (canDelete) {
      ref
          .read(editTeamProvider.notifier)
          .deleteTeam(id: widget.initialData.id!);
    }
  }

  void _onSave() {
    final name = _nameTextController.text.trim();
    final city = _cityTextController.text.trim();

    if (name.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните название и город')),
      );
      return;
    }

    ref
        .read(editTeamProvider.notifier)
        .saveTeam(
          teamId: widget.initialData.id,
          name: name,
          city: city,
          photo: _photo,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(editTeamProvider, (previous, next) {
      if (next is EditTeamSaved) {
        context.router.pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Команда успешно сохранена')),
        );
      }

      if (next is EditTeamDeleted) {
        context.router.popUntilRoot();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Команда успешно удалена')),
        );
      }

      if (next is EditTeamError) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Произошла ошибка"),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    final editState = ref.watch(editTeamProvider);
    final isLoading = editState is EditTeamLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ScreenWrapper(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    EditTeamAppBar(
                      title: widget.title,
                      onBackPressed: () {
                        context.router.pop();
                      },
                      onDeletePressed: canDelete ? _onDelete : null,
                    ),
                    const SizedBox(height: 24),
                    AddPhotoWidget(
                      size: 200,
                      initialPhotoUrl: widget.initialData.photoUrl,
                      onImageSelected: (file) {
                        setState(() {
                          _photo = file;
                        });
                      },
                      onImageDelete: _onImageDelete,
                    ),
                    const SizedBox(height: 24),
                    FormTile(
                      title: "Название команды:",
                      hint: "Название",
                      controller: _nameTextController,
                    ),
                    const SizedBox(height: 12),
                    FormTile(
                      title: "Город:",
                      hint: "Город",
                      controller: _cityTextController,
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

class EditTeamScreenInitial {
  final String? id;
  final String? name;
  final String? city;
  final String? photoUrl;
  final File? photo;

  const EditTeamScreenInitial({
    this.id,
    this.name,
    this.city,
    this.photoUrl,
    this.photo,
  });
}
