import 'package:flutter/material.dart';
import '../../../utils/constants/colors/app_colors.dart';

/// Visual style variants for [AppActionButton].
///
/// - [gradient]: Primary CTA with the app gradient background.
/// - [solid]: Secondary action with a solid dark background and border.
/// - [destructive]: Outlined red button for dangerous actions (e.g. delete).
enum AppButtonStyle { gradient, solid, destructive }

/// A reusable action button used across all feature modules.
///
/// Supports three visual styles via [AppButtonStyle] and automatically
/// handles the disabled state when [onTap] is null.
///
/// Example usage:
/// ```dart
/// AppActionButton(
///   label: "SHARE",
///   icon: Icons.share_rounded,
///   style: AppButtonStyle.gradient,
///   onTap: () => controller.share(),
/// )
/// ```
class AppActionButton extends StatelessWidget {
  /// The button text label displayed next to the icon.
  final String label;

  /// The leading icon displayed before the label.
  final IconData icon;

  /// The visual style variant of the button.
  final AppButtonStyle style;

  /// Callback invoked on tap. Pass null to disable the button.
  final VoidCallback? onTap;

  /// Creates an [AppActionButton].
  ///
  /// - [label]: The text shown on the button.
  /// - [icon]: The icon shown before the label.
  /// - [style]: The visual variant (gradient, solid, or destructive).
  /// - [onTap]: The tap handler. Null disables the button.
  const AppActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.style,
    required this.onTap,
  });

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: _buildDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _foregroundColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: _foregroundColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    switch (style) {
      case AppButtonStyle.gradient:
        return BoxDecoration(
          gradient: _isEnabled ? AppColors.primaryGradient : null,
          color: _isEnabled ? null : AppColors.greatGreyOwl.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        );
      case AppButtonStyle.solid:
        return BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyBorder),
        );
      case AppButtonStyle.destructive:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isEnabled
                ? AppColors.error
                : AppColors.error.withValues(alpha: 0.3),
          ),
        );
    }
  }

  Color get _foregroundColor {
    if (style == AppButtonStyle.destructive) {
      return _isEnabled
          ? AppColors.error
          : AppColors.error.withValues(alpha: 0.3);
    }
    return AppColors.white;
  }
}