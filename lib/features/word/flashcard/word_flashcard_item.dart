import 'package:flutter/material.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:untitled/features/word/flashcard/word_flashcard_back_item.dart';
import 'package:untitled/features/word/flashcard/word_flashcard_front_item.dart';
import '../../../models/word.dart';

class WordFlashcardItem extends StatelessWidget {
  const WordFlashcardItem({Key? key, required this.item, required this.pageKey}) : super(key: key);
  final Word item;
  final GlobalKey<PageFlipBuilderState> pageKey;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:(){
          pageKey.currentState?.flip();
        },
        child: PageFlipBuilder(
          key: pageKey,
          interactiveFlipEnabled: false,
          maxTilt: 0.003,
          maxScale: 0.1,
          nonInteractiveAnimationDuration: const Duration(seconds: 1),
          frontBuilder: (_) => WordFlashCardFrontItem(item: item),
          backBuilder: (_) => WordFlashCardBackItem(item: item),
        )
    );
  }
}
