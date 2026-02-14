import 'package:flutter/material.dart';

import '../../../../../../core/utils/utils/constants/colors/app_colors.dart';

class CaptureOptionItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

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