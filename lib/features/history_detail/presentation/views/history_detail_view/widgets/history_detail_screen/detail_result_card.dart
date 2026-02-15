import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/history_detail_controller.dart';

/// Displays the processing result text from the history record.
///
/// [DetailResultCard] shows the extracted text content as selectable
/// text. It is only visible when the result is not empty.
class DetailResultCard extends GetView<HistoryDetailController> {
  const DetailResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.historyItem.result.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "RESULT",
                style: TextStyle(
                  color: AppColors.tawnyOwl,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Icon(Icons.auto_awesome, color: AppColors.greatGreyOwl, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          SelectableText(
            controller.historyItem.result,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
