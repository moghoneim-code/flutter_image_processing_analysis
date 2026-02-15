import 'package:flutter/material.dart';

import '../../../utils/constants/colors/app_colors.dart';

/// A themed search text field for filtering and searching content.
///
/// [SearchTextField] provides a dark-themed input with a search icon
/// prefix and a clear button suffix. It invokes [onChanged] on every
/// keystroke so the parent can reactively filter its content.
class SearchTextField extends StatefulWidget {
  /// Callback invoked with the current search text on every change.
  final ValueChanged<String> onChanged;

  /// Optional hint text displayed when the field is empty.
  final String hint;

  /// Creates a [SearchTextField] widget.
  const SearchTextField({
    super.key,
    required this.onChanged,
    this.hint = 'Search text...',
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: TextStyle(color: AppColors.white, fontSize: 14),
      cursorColor: AppColors.tawnyOwl,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: AppColors.greyText, fontSize: 14),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.greatGreyOwl, size: 20),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (_, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.close_rounded, color: AppColors.greyText, size: 18),
              onPressed: () {
                _controller.clear();
                widget.onChanged('');
              },
            );
          },
        ),
        filled: true,
        fillColor: AppColors.bgSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.greyBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.greyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.tawnyOwl.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}
