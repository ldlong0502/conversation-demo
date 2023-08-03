import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_multiple_choice_cubit/kanji_multiple_choice_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/features/kanji/multiple_choice/answer_item.dart';
class BodyQuestion extends StatelessWidget {
  const BodyQuestion({Key? key, required this.state}) : super(key: key);
  final KanjiMultipleChoiceLoaded state;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColor.whiteAccent2,
      ),
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                    child: AutoSizeText(
                      state.listChoices[state.indexCurrent].question,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      style: AppStyle.kTitle.copyWith(fontSize: 25, color: Colors.black87),
                    ),
                  ))),
          Expanded(
              flex: 3,
              child:
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                AnswerItem(state: state, index: 0, ans: state.listChoices[state.indexCurrent].a),
                AnswerItem(state: state, index: 1, ans: state.listChoices[state.indexCurrent].b),
                AnswerItem(state: state, index: 2, ans: state.listChoices[state.indexCurrent].c),
                AnswerItem(state: state, index: 3, ans: state.listChoices[state.indexCurrent].d),
              ]))
        ],
      ),
    );
  }
}
