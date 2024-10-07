import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ReadMoreTextContainer extends StatelessWidget {
  final String text;
  final int? trimLines;
  final TextStyle? textStyle;
  final TextStyle? showMoreTextStyle;
  final TextStyle? showLessTextStyle;
  const ReadMoreTextContainer(
      {super.key,
      required this.text,
      this.textStyle,
      this.trimLines,
      this.showLessTextStyle,
      this.showMoreTextStyle});

  @override
  Widget build(BuildContext context) {
    final TextStyle showMoreAndReadLessTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      decorationThickness: 2.0,
    );
    return ReadMoreText(
      text,
      trimLines: trimLines ?? 3,
      trimMode: TrimMode.Line,
      // Show More & Show less
      trimCollapsedText: 'Lebih banyak',
      trimExpandedText: 'Lebih sedikit',
      style: textStyle ??
          TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.75)),
      lessStyle: showLessTextStyle ?? showMoreAndReadLessTextStyle,
      moreStyle: showMoreTextStyle ?? showMoreAndReadLessTextStyle,
    );
  }
}
