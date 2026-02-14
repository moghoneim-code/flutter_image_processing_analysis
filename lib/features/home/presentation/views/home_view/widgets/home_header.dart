import 'package:flutter/material.dart';
import 'package:flutter_image_processing_analysis/core/helper/snackbar_helper.dart';
import '../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../../../../core/utils/utils/constants/strings/app_images.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(AppImages.appLogo,height: 64,),
              const SizedBox(width: 12),
              Text(
                "ImageFlow",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.elfOwl,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.auto_awesome_mosaic_rounded, color: AppColors.tawnyOwl),
              onPressed: () {
                SnackBarHelper.showInfoMessage('Im Just A Demo Button 😅');
              },
            ),
          ),
        ],
      ),
    );
  }
}