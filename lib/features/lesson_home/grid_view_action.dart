import 'package:flutter/material.dart';
import 'package:untitled/features/lesson_home/action_item.dart';

import '../../enums/app_text.dart';
import '../../routes/app_routes.dart';
class GridViewAction extends StatelessWidget {
  const GridViewAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listItems = [
      {
        'title': AppTextTranslate.getTranslatedText(EnumAppText.txtListeningPractice),
        'iconUrl': 'assets/images/ic_listening.png',
        'onPress': () {
          Navigator.pushNamed(
              context, AppRoutes.practiceListening);
        }
      },
      {
        'title': AppTextTranslate.getTranslatedText(EnumAppText.txtKanji),
        'iconUrl': 'assets/images/ic_kanji.png',
        'onPress': () {
          Navigator.pushNamed(
              context, AppRoutes.kanji);
        }
      },
      {
        'title': AppTextTranslate.getTranslatedText(EnumAppText.txtVocabulary),
        'iconUrl': 'assets/images/ic_vocabulary.png',
        'onPress': () {}
      },
      {
        'title': AppTextTranslate.getTranslatedText(EnumAppText.txtGrammar),
        'iconUrl': 'assets/images/ic_grammar.png',
        'onPress': () {
          Navigator.pushNamed(
              context,AppRoutes.grammar);
        }
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 30),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            childAspectRatio: 0.9,
            mainAxisSpacing: 10// Số cột
        ),
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return ActionItem(
              title: listItems[index]['title'] as String,
              iconUrl: listItems[index]['iconUrl'] as String,
              onPress: listItems[index]['onPress']as Function());
        },
      ),
    );
  }
}
