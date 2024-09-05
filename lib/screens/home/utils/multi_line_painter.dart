import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';

class MultiLinePainter extends CustomPainter {
  final double progress;
  final String text;
  final TextStyle textStyle;
  final double maxWidth;

  MultiLinePainter({
    required this.progress,
    required this.text,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );

    textPainter.layout(maxWidth: maxWidth);

    double totalHeight = textPainter.height;
    double lineHeight = textPainter.preferredLineHeight;
    int totalLines = (totalHeight / lineHeight).ceil();

    for (int i = 0; i < totalLines; i++) {
      // Get the offset of the current line
      final lineMetrics = textPainter.computeLineMetrics()[i];
      final lineStartOffset = lineMetrics.left;
      final lineEndOffset = lineMetrics.width;

      final start = Offset(lineStartOffset, lineHeight * i + lineHeight / 2);
      final end = Offset(lineStartOffset + (lineEndOffset * progress),
          lineHeight * i + lineHeight / 2);

      final paint = Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
