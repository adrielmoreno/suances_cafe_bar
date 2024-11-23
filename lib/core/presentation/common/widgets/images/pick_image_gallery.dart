import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../extensions/widget_extensions.dart';
import '../../theme/constants/dimens.dart';

class PickImageGallery extends StatelessWidget {
  const PickImageGallery({super.key, required this.onFile});
  final Function(File?) onFile;

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
              onPressed: () => context.pickImage(ImageSource.camera, onFile),
              icon: const Icon(Icons.camera),
              label: const Text('Cámara'),
            ),
            ElevatedButton.icon(
              onPressed: () => context.pickImage(ImageSource.gallery, onFile),
              icon: const Icon(Icons.photo_library),
              label: const Text('Galería'),
            ),
          ],
        ),
      ],
    );
  }
}
