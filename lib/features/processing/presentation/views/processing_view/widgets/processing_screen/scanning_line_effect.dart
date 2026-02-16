import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/utils/constants/colors/app_colors.dart';

/// Animated scanning line that sweeps vertically across its parent.
///
/// [ScanningLineEffect] creates a glowing horizontal line that
/// animates up and down continuously, simulating a scanning effect
/// over the image preview during processing.
class ScanningLineEffect extends StatefulWidget {
  /// Creates a [ScanningLineEffect] instance.
  const ScanningLineEffect({super.key});

  @override
  State<ScanningLineEffect> createState() => _ScanningLineEffectState();
}

class _ScanningLineEffectState extends State<ScanningLineEffect>
    with SingleTickerProviderStateMixin {
  /// Animation controller driving the vertical sweep.
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: Alignment(0, _controller.value * 2 - 1),
          child: Container(
            height: 2,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.burrowingOwl,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.burrowingOwl,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}