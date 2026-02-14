import 'package:flutter/material.dart';

import '../../../../../../../core/utils/utils/constants/colors/app_colors.dart';

class EmptyHistoryView extends StatelessWidget {
  const EmptyHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.blur_on_rounded, size: 100, color: AppColors.greatGreyOwl.withValues(alpha: 0.5)),
          const SizedBox(height: 20),
          Text(
            "Your history is empty",
            style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            "Start processing images to see them here",
            style: TextStyle(color: AppColors.greyText, fontSize: 14),
          ),
        ],
      ),
    );
  }
}