import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';

/// Shimmer loading placeholder displayed while history data is being fetched.
///
/// [HistoryShimmerLoading] renders five shimmer card skeletons that
/// mimic the layout of [HistoryCard] to provide visual feedback
/// during the loading state.
class HistoryShimmerLoading extends StatelessWidget {
  /// Creates a [HistoryShimmerLoading] instance.
  const HistoryShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.bgSecondary,
          highlightColor: AppColors.greatGreyOwl.withOpacity(0.2),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 150, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 10, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}