import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../config/routes/app_routes.dart';
import '../../../../../../../core/shared/widgets/buttons/app_action_button.dart';

/// A row of action buttons for the no-result screen.
///
/// [NoResultActionButtons] provides two side-by-side buttons:
/// - **GO HOME**: Navigates to the home screen, clearing the stack.
/// - **TRY AGAIN**: Returns to the home screen so the user can pick
///   a new image for analysis.
class NoResultActionButtons extends StatelessWidget {
  /// Creates a [NoResultActionButtons] widget.
  const NoResultActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppActionButton(
            label: "GO HOME",
            icon: Icons.home_rounded,
            style: AppButtonStyle.solid,
            onTap: () => Get.offAllNamed(AppRoutes.home),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppActionButton(
            label: "TRY AGAIN",
            icon: Icons.refresh_rounded,
            style: AppButtonStyle.gradient,
            onTap: () => Get.offAllNamed(AppRoutes.home),
          ),
        ),
      ],
    );
  }
}
