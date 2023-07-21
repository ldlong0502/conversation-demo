import 'dart:ui';

import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class ColumnTextPhonetic extends StatelessWidget {
  const ColumnTextPhonetic(
      {Key? key,
      required this.textPhonetic,
      required this.textFurigana,
      required this.color,
      required this.isPhonetic,
      required this.isBlur})
      : super(key: key);
  final String textPhonetic;
  final String textFurigana;
  final Color color;
  final bool isPhonetic;
  final bool isBlur;

  @override
  Widget build(BuildContext context) {
    return isPhonetic
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(textPhonetic, style: kPhonetic.copyWith(color: color)),
              Text(textFurigana,
                  style: kSentenceForeign.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..color = color
                        ..maskFilter =
                             MaskFilter.blur(BlurStyle.normal, isBlur ? 0 : 1 ))),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(textFurigana,
                  style: kSentenceForeign.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..color = color
                        ..maskFilter =
                        MaskFilter.blur(BlurStyle.normal, isBlur ? 0 : 1 ))),
            ],
          );
  }
}
