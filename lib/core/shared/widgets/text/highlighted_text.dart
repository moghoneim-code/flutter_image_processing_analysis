import 'package:flutter/material.dart';

/// A widget that displays text with search query matches highlighted.
///
/// [HighlightedText] splits the [text] by occurrences of [query]
/// (case-insensitive) and renders matching portions with an orange
/// background highlight. Non-matching portions retain the base [style].
///
/// If [query] is empty, the full [text] is rendered without highlights.
class HighlightedText extends StatelessWidget {
  /// The full text content to display.
  final String text;

  /// The search query to highlight within [text].
  final String query;

  /// The base text style applied to non-highlighted portions.
  final TextStyle? style;

  /// The maximum number of lines before truncating with ellipsis.
  final int? maxLines;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// Creates a [HighlightedText] widget.
  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final spans = _buildHighlightedSpans();

    return RichText(
      text: TextSpan(children: spans, style: style),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }

  /// Splits [text] by case-insensitive [query] matches and returns
  /// a list of [TextSpan] with matched portions highlighted in orange.
  List<TextSpan> _buildHighlightedSpans() {
    final List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;

    while (start < text.length) {
      final matchIndex = lowerText.indexOf(lowerQuery, start);

      if (matchIndex == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (matchIndex > start) {
        spans.add(TextSpan(text: text.substring(start, matchIndex)));
      }

      spans.add(
        TextSpan(
          text: text.substring(matchIndex, matchIndex + query.length),
          style: TextStyle(
            backgroundColor: Colors.orange.withValues(alpha: 0.4),
            color: Colors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

      start = matchIndex + query.length;
    }

    return spans;
  }
}
