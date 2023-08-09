import 'package:flutter/material.dart';
import 'package:untitled/configs/app_style.dart';

import '../../configs/app_color.dart';

class WordExampleText extends StatelessWidget {
  const WordExampleText({Key? key, required this.example}) : super(key: key);
  final String example;
  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    RegExp regex = RegExp(r"{(.*?)}");
    Iterable<Match> matches = regex.allMatches(example);

    int prevEnd = 0;
    for (var match in matches) {
      if (match.start > prevEnd) {
        textSpans.add(
          TextSpan(
            text: example.substring(prevEnd, match.start),
            style:  AppStyle.kSubTitle.copyWith(color: Colors.black),
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
    if (prevEnd < example.length) {
      textSpans.add(
        TextSpan(
          text: example.substring(prevEnd),
          style: AppStyle.kSubTitle.copyWith(color: Colors.black),
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
