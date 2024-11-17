import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/extensions/widget_extensions.dart';
import '../../../common/theme/constants/dimens.dart';

class PickImageGallery extends StatefulWidget {
  const PickImageGallery({super.key, required this.onFile});
  final Function(File?) onFile;

  @override
  State<PickImageGallery> createState() => _PickImageGalleryState();
}

class _PickImageGalleryState extends State<PickImageGallery> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Dimens.medium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera),
              label: const Text('Cámara'),
            ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Galería'),
            ),
          ],
        ),
      ],
    );
  }

  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    var status = await permission.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      await openAppSettings();
    }

    if (status.isGranted || status.isLimited) {
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 20);

      if (pickedFile != null) {
        widget.onFile(File(pickedFile.path));
      }
    } else {
      // ignore: use_build_context_synchronously
      context.showSnackBar('Permiso para acceder denegado');
    }
  }
}
