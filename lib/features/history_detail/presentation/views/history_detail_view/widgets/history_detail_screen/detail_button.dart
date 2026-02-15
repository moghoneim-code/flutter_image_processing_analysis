import 'package:flutter/material.dart';
import '../../../../../../../core/utils/constants/colors/app_colors.dart';

/// Visual style variants for [DetailButton].
enum DetailButtonStyle { gradient, solid, destructive }

/// A configurable action button for the history detail screen.
///
/// Supports three visual styles: gradient (primary CTA), solid (secondary),
/// and destructive (outlined red). Disabled state is derived from [onTap]
/// being null.
class DetailButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final DetailButtonStyle style;
  final VoidCallback? onTap;

  const DetailButton({
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
        width: style == DetailButtonStyle.destructive ? double.infinity : null,
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
      case DetailButtonStyle.gradient:
        return BoxDecoration(
          gradient: _isEnabled ? AppColors.primaryGradient : null,
          color: _isEnabled ? null : AppColors.greatGreyOwl.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        );
      case DetailButtonStyle.solid:
        return BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyBorder),
        );
      case DetailButtonStyle.destructive:
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
    if (style == DetailButtonStyle.destructive) {
      return _isEnabled
          ? AppColors.error
          : AppColors.error.withValues(alpha: 0.3);
    }
    return AppColors.white;
  }
}
