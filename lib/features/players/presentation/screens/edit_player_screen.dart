import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/add_photo_widget.dart';
import 'package:ultistats/core/widgets/confirm_edit_button.dart';
import 'package:ultistats/core/widgets/form_tile.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/players/presentation/providers/edit_player_notifier.dart';
import 'package:ultistats/features/players/presentation/widgets/common/edit_player_app_bar.dart';

@RoutePage()
class EditPlayerScreen extends ConsumerStatefulWidget {
  const EditPlayerScreen({
    super.key,
    required this.title,
    required this.confirmButtonText,
    this.initialData = const EditPlayerScreenInitial(),
  });

  final String title;
  final String confirmButtonText;
  final EditPlayerScreenInitial initialData;

  @override
  ConsumerState<EditPlayerScreen> createState() => _EditPlayerScreenState();
}

class _EditPlayerScreenState extends ConsumerState<EditPlayerScreen> {
  late final TextEditingController _nameTextController;
  late final TextEditingController _secondNameTextController;
  File? _photo;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(text: widget.initialData.name);
    _secondNameTextController = TextEditingController(
      text: widget.initialData.secondName,
    );
    _photo = widget.initialData.photo;
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _secondNameTextController.dispose();
    super.dispose();
  }

  void _onImageDelete() {
    /// If widget.initialData.id == null
    /// the player is not exist
    if (widget.initialData.id != null) {
      ref.read(editPlayerProvider.notifier).deleteImage(widget.initialData.id!);
    }
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
          playerId: widget.initialData.id,
          firstName: name,
          lastName: secondName,
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

class EditPlayerScreenInitial {
  final String? id;
  final String? name;
  final String? secondName;
  final String? photoUrl;
  final File? photo;

  const EditPlayerScreenInitial({
    this.id,
    this.name,
    this.secondName,
    this.photoUrl,
    this.photo,
  });
}
