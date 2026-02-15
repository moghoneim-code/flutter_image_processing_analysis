import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../errors/failures.dart';
import '../../utils/constants/colors/app_colors.dart';

/// Service for picking and cropping images from the device.
///
/// [ImagePickerService] wraps the [ImagePicker] and [ImageCropper]
/// plugins to provide a streamlined image selection flow with
/// optional cropping support on both Android and iOS.
class ImagePickerService {
  /// Internal [ImagePicker] instance used for camera and gallery access.
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the specified [source] and opens the crop editor.
  ///
  /// - [source]: Either [ImageSource.camera] or [ImageSource.gallery].
  ///
  /// Returns the cropped image [File], or `null` if the user cancels
  /// at any stage (picking or cropping).
  ///
  /// Throws an [ImagePickerFailure] if the operation fails.
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return null;

      return await _cropImage(pickedFile.path);
    } catch (e) {
      if (e is ImagePickerFailure) rethrow;
      throw ImagePickerFailure('Failed to pick image: $e');
    }
  }

  /// Opens the image cropper UI for the image at [filePath].
  ///
  /// Configures platform-specific crop UI settings with the
  /// application's brand colors for a consistent visual experience.
  ///
  /// Returns the cropped [File], or `null` if the user cancels.
  /// Throws an [ImagePickerFailure] if cropping fails.
  Future<File?> _cropImage(String filePath) async {
    try {
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
    } catch (e) {
      if (e is ImagePickerFailure) rethrow;
      throw ImagePickerFailure('Failed to crop image: $e');
    }
  }
}