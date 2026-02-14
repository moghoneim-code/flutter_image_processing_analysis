import 'package:flutter/material.dart';
import '../../../../../../../core/utils/utils/constants/colors/app_colors.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPdf; // تمييز ملفات الـ PDF

  const HistoryCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
    this.isPdf = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.greatGreyOwl.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            // لو PDF خليه أحمر (لون الـ PDF المعروف)، لو نص خليه بالـ Gradient بتاعك
            gradient: isPdf
                ? LinearGradient(
                    colors: [AppColors.burrowingOwl, AppColors.tawnyOwl],
                  )
                : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isPdf ? Icons.picture_as_pdf_rounded : icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Text(
              subTitle,
              style: TextStyle(color: AppColors.greyText, fontSize: 12),
            ),
            if (isPdf) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "PDF",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.greatGreyOwl,
          size: 16,
        ),
      ),
    );
  }
}
