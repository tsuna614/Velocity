import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines; // The number of lines before it is shortened.

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 2,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  bool isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Check if the text overflows
        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        isOverflowing = textPainter.didExceedMaxLines;

        return GestureDetector(
          onTap: () {
            if (widget.text.length <= 100) return;
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: isExpanded ? widget.text : _getShortText(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                if (isOverflowing || isExpanded)
                  TextSpan(
                    text: isExpanded ? '  See less' : '... See more',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getShortText() {
    // Get shortened text for display with ellipsis
    if (widget.text.length > 100) {
      return widget.text
          .substring(0, 100); // Adjust based on the length you want
    } else {
      return widget.text;
    }
  }
}
