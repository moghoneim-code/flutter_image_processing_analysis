import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/colors/app_colors.dart';

/// A tappable icon button used in the image capture method bottom sheet.
///
/// [CaptureOptionItem] displays a styled icon inside a rounded container
/// with a label below it. Used within [CustomBottomSheets.showImagePicker]
/// to present capture options (Camera, Live AI, Gallery).
///
/// Required data:
/// - [label]: The text displayed below the icon.
/// - [icon]: The [IconData] rendered inside the container.
/// - [onTap]: Callback invoked when the item is tapped.
class CaptureOptionItem extends StatelessWidget {
  /// The text label displayed below the icon.
  final String label;

  /// The icon displayed inside the rounded container.
  final IconData icon;

  /// Callback invoked when the option is tapped.
  final VoidCallback onTap;

  /// Creates a [CaptureOptionItem] with the given properties.
  const CaptureOptionItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.elfOwl,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.burrowingOwl.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: AppColors.burrowingOwl, size: 30),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}