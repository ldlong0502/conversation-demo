import 'package:flutter/material.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:untitled/features/grammar/float_lecture_button.dart';
import '../../../models/grammar.dart';
import '../../configs/app_color.dart';
import '../../widgets/app_bar_custom.dart';

class GrammarDetailsPage extends StatelessWidget {
  const GrammarDetailsPage({Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    final grammar = ModalRoute.of(context)!.settings.arguments as Grammar;
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarCustom(
          title: grammar.mean.toUpperCase(),
          bgColor: AppColor.white,
          textColor: AppColor.blue,
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  bodyDetailGrammar(grammar),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
           FloatLectureButton(grammar: grammar)
          ],
        ),
      ),
    );
  }

  bodyDetailGrammar(Grammar grammar) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          categoryTitle(
              AppTextTranslate.getTranslatedText(EnumAppText.txtStructure), Icons.account_tree),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              grammar.structures,
              style: AppStyle.kTitle.copyWith(fontSize: 15, color: Colors.black),
            ),
          ),
          categoryTitle(AppTextTranslate.getTranslatedText(EnumAppText.txtUsage), Icons.lightbulb_outline_rounded),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              grammar.uses,
              style: AppStyle.kTitle.copyWith(fontSize: 15, color: Colors.black),
            ),
          ),
          categoryTitle(AppTextTranslate.getTranslatedText(EnumAppText.txtNote), Icons.highlight_rounded),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              grammar.note,
              style: AppStyle.kTitle.copyWith(fontSize: 15, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  categoryTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: AppColor.blue,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: AppStyle.kTitle.copyWith(fontSize: 20),
          )
        ],
      ),
    );
  }
}
