import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/history_detail_controller.dart';

/// Displays metadata about the history record.
///
/// [DetailMetadataCard] shows the processing type as a badge,
/// the formatted creation date, and the file size in a styled card.
class DetailMetadataCard extends GetView<HistoryDetailController> {
  const DetailMetadataCard({super.key});

  @override
  Widget build(BuildContext context) {
    final item = controller.historyItem;
    final typeName = item.type.name[0].toUpperCase() + item.type.name.substring(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DETAILS",
            style: TextStyle(
              color: AppColors.tawnyOwl,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildRow(
            icon: Icons.category_rounded,
            label: "Type",
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.burrowingOwl.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                typeName,
                style: TextStyle(
                  color: AppColors.burrowingOwl,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildRow(
            icon: Icons.calendar_today_rounded,
            label: "Date",
            child: Text(
              item.dateTime,
              style: TextStyle(color: AppColors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 14),
          Obx(() => _buildRow(
                icon: Icons.storage_rounded,
                label: "Size",
                child: Text(
                  controller.fileSize.value.isNotEmpty
                      ? controller.fileSize.value
                      : "Unknown",
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.greatGreyOwl, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: AppColors.greyText, fontSize: 14),
        ),
        const Spacer(),
        child,
      ],
    );
  }
}
