import 'package:flutter/material.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';

/// An informational message indicating no content was detected.
///
/// [NoResultInfoMessage] displays a search icon, a title, and a
/// descriptive subtitle guiding the user to try a different image.
class NoResultInfoMessage extends StatelessWidget {
  /// Creates a [NoResultInfoMessage] widget.
  const NoResultInfoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.image_search_rounded,
          color: AppColors.greyText,
          size: 40,
        ),
        const SizedBox(height: 12),
        const Text(
          "No faces or text detected",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "This image doesn't appear to contain recognizable faces "
          "or readable text. Try a different image.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.greyText,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
