import 'package:flutter/material.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:untitled/features/kanji/flashcard/back_item.dart';
import 'package:untitled/features/kanji/flashcard/front_item.dart';

import '../../../models/kanji.dart';

class FlashcardItem extends StatelessWidget {
  const FlashcardItem({Key? key, required this.item, required this.pageKey}) : super(key: key);
  final Kanji item;
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
          frontBuilder: (_) => FrontItem(item: item,),
          backBuilder: (_) => BackItem(item: item),
        )
    );
  }
}
