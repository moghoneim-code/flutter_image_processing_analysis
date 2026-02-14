import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/utils/constants/colors/app_colors.dart';

class ScanningLineEffect extends StatefulWidget {
  const ScanningLineEffect({super.key});

  @override
  State<ScanningLineEffect> createState() => _ScanningLineEffectState();
}

class _ScanningLineEffectState extends State<ScanningLineEffect>
    with SingleTickerProviderStateMixin {
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
