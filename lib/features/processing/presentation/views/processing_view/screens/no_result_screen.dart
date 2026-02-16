import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../config/routes/app_routes.dart';
import '../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../domain/entities/processing_result.dart';
import '../widgets/no_result_screen/no_result_action_buttons.dart';
import '../widgets/no_result_screen/no_result_image_preview.dart';
import '../widgets/no_result_screen/no_result_info_message.dart';

/// Screen displayed when image analysis finds no recognizable content.
///
/// [NoResultScreen] presents the analyzed image, an informational message,
/// and action buttons to retry with a different image or return home.
///
/// This screen receives a [ProcessingResult] via route arguments and
/// is accessed through the `/no-result` route.
class NoResultScreen extends StatelessWidget {
  /// Creates a [NoResultScreen] widget.
  const NoResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = Get.arguments as ProcessingResult;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.offAllNamed(AppRoutes.home),
        ),
        title: const Text(
          "Analysis Complete",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Expanded(child: NoResultImagePreview(imageFile: result.file)),

            const SizedBox(height: 24),

            const NoResultInfoMessage(),

            const SizedBox(height: 24),

            const NoResultActionButtons(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
