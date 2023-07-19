import 'package:flutter/material.dart';

import '../../constants/constants.dart';
class ColumnTextPhonetic extends StatelessWidget {
  const ColumnTextPhonetic({Key? key, required this.textPhonetic, required this.textFurigana, required this.color}) : super(key: key);
  final String textPhonetic;
  final String textFurigana;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(textPhonetic,
            style: kPhonetic.copyWith(
                color: color
            )),
        Text(textFurigana,
            style: kSentenceForeign.copyWith(
                color: color,
            )),
      ],
    );
  }
}
