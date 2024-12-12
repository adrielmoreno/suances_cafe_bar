import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../localization/localization_manager.dart';
import '../theme/constants/app_colors.dart';

extension WidgetExtensions on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 800),
    ));
  }

  Future<DateTime?> selectedDatePicker() async {
    return await showDatePicker(
      context: this,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  Future<void> pickImage(
      ImageSource source, final Function(File?) onFile) async {
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
        File? croppedFile = await _cropImage(pickedFile.path);
        onFile(croppedFile);
      }
    } else {
      showSnackBar('Permiso para acceder denegado');
    }
  }

  Future<File?> _cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      compressQuality: 20,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: text.crop_image_title,
          toolbarColor: AppColors.primaryLight,
          toolbarWidgetColor: AppColors.onBackgroundDark,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: text.crop_image_title,
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
