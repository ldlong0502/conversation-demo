import 'package:flutter/material.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/models/vocabulary_kanji.dart';

import '../../../utils/split_text.dart';

class FuriganaColumnText extends StatelessWidget {
  const FuriganaColumnText({Key? key, required this.vocabulary}) : super(key: key);
  final VocabularyKanji vocabulary;
  @override
  Widget build(BuildContext context) {
    var list = SplitText().splitFuriganaVoc(vocabulary.furigana);
    return Row(
      children: list.map((e) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              e.split('|')[1],
              style: AppStyle.kSubTitle,
            ),
            Text(
              e.split('|')[0],
              style: AppStyle.kTitle,
            ),
          ],
        );
      }).toList(),
    );
  }
}
