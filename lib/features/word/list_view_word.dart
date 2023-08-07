import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/features/grammar/grammar_item.dart';
import 'package:untitled/features/word/word_item.dart';

import '../../models/grammar.dart';
import '../../models/word.dart';

class ListViewWord extends StatelessWidget {
  const ListViewWord({Key? key, required this.listWord})
      : super(key: key);
  final List<Word> listWord;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10 , bottom: 200),
        itemCount: listWord.length,
        itemBuilder: (context, index) {
          return WordItem(word: listWord[index]);
        });
  }
}
