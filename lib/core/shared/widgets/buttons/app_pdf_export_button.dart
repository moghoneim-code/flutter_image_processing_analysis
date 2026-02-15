import 'package:flutter/material.dart';
import '../../../utils/constants/colors/app_colors.dart';

/// A reusable gradient-styled button for triggering PDF export.
///
/// Shows a loading spinner and changes the label text while [isLoading]
/// is true. The button is automatically disabled during loading.
///
/// Example usage:
/// ```dart
/// Obx(() => AppPdfExportButton(
///   label: "SAVE AS PDF DOCUMENT",
///   loadingLabel: "GENERATING PDF...",
///   isLoading: controller.isProcessing.value,
///   onPressed: () => controller.generatePDF(),
/// ))
/// ```
class AppPdfExportButton extends StatelessWidget {
  /// The default button text (e.g. "SAVE AS PDF DOCUMENT").
  final String label;

  /// The text shown while [isLoading] is true (e.g. "GENERATING PDF...").
  final String loadingLabel;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Callback invoked when the button is pressed. Ignored while loading.
  final VoidCallback onPressed;

  /// Creates an [AppPdfExportButton].
  ///
  /// - [label]: Text displayed in the default state.
  /// - [loadingLabel]: Text displayed during loading.
  /// - [isLoading]: Controls the loading spinner and disabled state.
  /// - [onPressed]: The action triggered on tap.
  const AppPdfExportButton({
    super.key,
    required this.label,
    required this.loadingLabel,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppColors.elfOwl, AppColors.burrowingOwl.withValues(alpha: 0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.elfOwl.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
        label: Text(
          isLoading ? loadingLabel : label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}