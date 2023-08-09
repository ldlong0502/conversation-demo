import 'package:flutter/material.dart';
import 'package:untitled/configs/app_style.dart';

import '../../configs/app_color.dart';

class WordExampleMeanText extends StatelessWidget {
  const WordExampleMeanText({Key? key, required this.exampleMean}) : super(key: key);
  final String exampleMean;
  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    RegExp regex = RegExp(r"{(.*?)}");
    Iterable<Match> matches = regex.allMatches(exampleMean);

    int prevEnd = 0;
    for (var match in matches) {
      if (match.start > prevEnd) {
        textSpans.add(
          TextSpan(
            text: exampleMean.substring(prevEnd, match.start),
            style:  AppStyle.kSubTitle.copyWith(color: AppColor.blue),
          ),
        );
      }
      textSpans.add(
        TextSpan(
          text: match.group(1),
          style: AppStyle.kTitle.copyWith(color: AppColor.red),
        ),
      );
      prevEnd = match.end;
    }
    if (prevEnd < exampleMean.length) {
      textSpans.add(
        TextSpan(
          text: exampleMean.substring(prevEnd),
          style: AppStyle.kSubTitle.copyWith(color: AppColor.blue),
        ),
      );
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
