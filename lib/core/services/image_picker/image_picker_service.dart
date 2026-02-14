import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart'; // مهم عشان ألوان الـ UI
import '../../utils/utils/constants/colors/app_colors.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;

    return await _cropImage(pickedFile.path);
  }

  Future<File?> _cropImage(String filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.bgPrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          activeControlsWidgetColor: AppColors.burrowingOwl,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          doneButtonTitle: 'Done',
          cancelButtonTitle: 'Cancel',
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }
}