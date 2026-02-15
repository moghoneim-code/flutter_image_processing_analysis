import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../../../core/utils/constants/colors/app_colors.dart';

/// A card widget representing a single history record in the list.
///
/// [HistoryCard] displays a leading icon, title, subtitle with date,
/// and an optional PDF badge. It supports tap interaction for
/// opening the associated file.
///
/// Required data:
/// - [title]: The primary text (processing result or document label).
/// - [subTitle]: The secondary text (typically the creation timestamp).
/// - [icon]: The leading icon representing the content type.
/// - [onTap]: Callback invoked when the card is tapped.
/// - [isPdf]: Whether to display the PDF badge and gradient styling.
class HistoryCard extends StatelessWidget {
  /// The primary display text for this history entry.
  final String title;

  /// The secondary display text, typically the creation date.
  final String subTitle;

  /// The icon representing the processing type.
  final IconData icon;

  /// Callback invoked when the card is tapped.
  final VoidCallback onTap;

  /// Whether this entry represents a PDF document.
  final bool isPdf;

  /// Optional file path to an image thumbnail for this entry.
  final String? imagePath;

  /// Creates a [HistoryCard] with the given display properties.
  const HistoryCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
    this.isPdf = false,
    this.imagePath,
  });

  Widget _buildLeading() {
    if (isPdf) return _buildGradientIcon(Icons.picture_as_pdf_rounded, isPdfStyle: true);

    if (imagePath != null && imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(imagePath!),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          cacheWidth: 100,
          errorBuilder: (_, e, s) => _buildGradientIcon(icon),
        ),
      );
    }

    return _buildGradientIcon(icon);
  }

  Widget _buildGradientIcon(IconData iconData, {bool isPdfStyle = false}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: isPdfStyle
            ? LinearGradient(colors: [AppColors.burrowingOwl, AppColors.tawnyOwl])
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: Colors.white),
    );
  }

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
        leading: _buildLeading(),
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
