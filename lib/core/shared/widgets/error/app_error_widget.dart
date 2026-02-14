import 'package:flutter/material.dart';

import '../../../models/ui_models/error_params.dart';
import '../../../utils/utils/constants/colors/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  final ErrorParams params;

  const AppErrorWidget({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 80, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              params.title!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              params.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (params.onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: params.onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.elfOwl,
                  foregroundColor: Colors.white,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}