import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../controllers/history_detail_controller.dart';
import '../widgets/history_detail_screen/detail_action_buttons.dart';
import '../widgets/history_detail_screen/detail_image_preview.dart';
import '../widgets/history_detail_screen/detail_metadata_card.dart';
import '../widgets/history_detail_screen/detail_result_card.dart';

/// Main screen for displaying a history record's full details.
///
/// [HistoryDetailScreen] presents the processed image, metadata
/// (date, type, file size), result text, and action buttons for
/// sharing, opening, and deleting the record.
///
/// This screen is bound to [HistoryDetailController] via
/// [HistoryDetailBinding] and accessed through the `/history-detail` route.
class HistoryDetailScreen extends GetView<HistoryDetailController> {
  const HistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Detail",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const DetailImagePreview(),
            const SizedBox(height: 24),
            const DetailMetadataCard(),
            const SizedBox(height: 20),
            const DetailResultCard(),
            const SizedBox(height: 32),
            const DetailActionButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
