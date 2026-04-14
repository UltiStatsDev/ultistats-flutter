import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class AddPhotoWidget extends StatefulWidget {
  final double size;
  final Function(File?) onImageSelected;

  const AddPhotoWidget({
    super.key,
    this.size = 120,
    required this.onImageSelected,
  });

  @override
  State<AddPhotoWidget> createState() => _AddPhotoWidgetState();
}

class _AddPhotoWidgetState extends State<AddPhotoWidget> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _image = file;
      });
      widget.onImageSelected(file);
    }
  }

  void _showPicker(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (bc) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('Галерея', style: theme.textTheme.labelLarge),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(bc).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('Камера', style: theme.textTheme.labelLarge),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(bc).pop();
                },
              ),
              if (_image != null)
                ListTile(
                  leading: const Icon(Icons.close),
                  title: Text('Удалить', style: theme.textTheme.labelLarge),
                  onTap: () {
                    setState(() {
                      _image = null;
                    });
                    Navigator.of(bc).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(theme.cardBorderRadius),
          image: _image != null
              ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
              : null,
        ),
        child: _image == null ? _placeholder(context) : null,
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_outlined,
          size: 96,
          color: theme.inputDecorationTheme.hintStyle!.color,
        ),
        SizedBox(height: 12),
        Text("Добавить фото", style: theme.inputDecorationTheme.hintStyle),
      ],
    );
  }
}
