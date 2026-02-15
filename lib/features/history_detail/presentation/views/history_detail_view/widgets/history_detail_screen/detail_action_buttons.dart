import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/shared/widgets/buttons/app_action_button.dart';
import '../../../../controllers/history_detail_controller.dart';
import 'delete_confirmation_dialog.dart';

/// A row of action buttons for sharing, opening, and deleting a history record.
///
/// [DetailActionButtons] provides three buttons:
/// - **SHARE**: Gradient button that shares the file via platform share sheet.
/// - **OPEN**: Solid button that opens the file in the default app.
/// - **DELETE**: Outlined red button that deletes the record.
///
/// All buttons are disabled while [HistoryDetailController.isProcessing] is true.
class DetailActionButtons extends GetView<HistoryDetailController> {
  const DetailActionButtons({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await DeleteConfirmationDialog.show(context);
    if (confirmed) {
      controller.deleteItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final disabled = controller.isProcessing.value;

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppActionButton(
                  label: "SHARE",
                  icon: Icons.share_rounded,
                  style: AppButtonStyle.gradient,
                  onTap: disabled ? null : () => controller.shareFile(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppActionButton(
                  label: "OPEN",
                  icon: Icons.open_in_new_rounded,
                  style: AppButtonStyle.solid,
                  onTap: disabled ? null : () => controller.openFile(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppActionButton(
            label: "DELETE",
            icon: Icons.delete_outline_rounded,
            style: AppButtonStyle.destructive,
            onTap: disabled ? null : () => _confirmDelete(context),
          ),
        ],
      );
    });
  }
}