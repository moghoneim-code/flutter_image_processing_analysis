// lib/features/processing/presentation/views/widgets/ambient_background_blur.dart

import 'package:flutter/material.dart';
import '../../../../../../core/utils/utils/constants/colors/app_colors.dart';

class AmbientBackgroundBlur extends StatelessWidget {
  const AmbientBackgroundBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // دائرة متوهجة في أعلى اليمين
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // بنستخدم لون الـ Owl الأساسي مع شفافية عالية جداً
              color: AppColors.burrowingOwl.withOpacity(0.08),
            ),
          ),
        ),

        // دائرة خفيفة في أسفل اليسار للتوازن البصري
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.tawnyOwl.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }
}