import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_multiple_choice_cubit/kanji_multiple_choice_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AnswerItem extends StatelessWidget {
  const AnswerItem({Key? key, required this.state, required this.index, required this.ans}) : super(key: key);
  final KanjiMultipleChoiceLoaded state;
  final String ans;
  final int index;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final cubit = context.watch<KanjiMultipleChoiceCubit>();
    return InkWell(
      onTap: () async {
        cubit.clickAnswer(index, getIndexOfAnswer());
        // if (isClick) return;
        // setState(() {
        //   isClick = true;
        //   listAnswersStatus = listAnswersStatus.map((e) {
        //     return 'isClick';
        //   }).toList();
        //   final indexAnswer = getIndexOfAnswer();
        //   if (index == indexAnswer) {
        //     playAudio(true);
        //     listAnswersStatus[index] = 'true';
        //     historyAnswers
        //         .add({'title': listChoices[indexCurent].title, 'answer': true});
        //   } else {
        //     playAudio(false);
        //     listAnswersStatus[index] = 'false';
        //     listAnswersStatus[indexAnswer] = 'true';
        //     historyAnswers.add(
        //         {'title': listChoices[indexCurent].title, 'answer': false});
        //   }
        // });
        //
        // await Future.delayed(Duration(seconds: 1))
        //     .then((value) => nextQuestion());
      },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 40,
        width: size.width - 40,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: getColor(index),
            boxShadow: [
              state.listAnswersStatus[index] != 'none'
                  ? const BoxShadow()
                  : BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
            border:
            Border.all(color: AppColor.grey, width: getBorderWidth(index))),
        child: Center(
          child: Text(
            ans,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: AppStyle.kTitle.copyWith(fontSize: 18, color: getTextColor(index)),
          ),
        ),
      ),
    );
  }
  getColor(int index) {
    if (state.listAnswersStatus[index] == 'none') {
      return AppColor.white;
    } else if (state.listAnswersStatus[index] == 'true') {
      return AppColor.green;
    } else if (state.listAnswersStatus[index] == 'false') {
      return AppColor.red;
    } else {
      return AppColor.whiteAccent2;
    }
  }

  double getBorderWidth(int index) {
    if (state.listAnswersStatus[index] == 'none') {
      return 1;
    } else if (state.listAnswersStatus[index] == 'true') {
      return 0;
    } else if (state.listAnswersStatus[index] == 'false') {
      return 0;
    } else {
      return 0.5;
    }
  }
  int getIndexOfAnswer() {
    if (state.listChoices[state.indexCurrent].answer == state.listChoices[state.indexCurrent].a) {
      return 0;
    } else if (state.listChoices[state.indexCurrent].answer == state.listChoices[state.indexCurrent].b) {
      return 1;
    } else if (state.listChoices[state.indexCurrent].answer == state.listChoices[state.indexCurrent].c) {
      return 2;
    }
    return 3;
  }

  getTextColor(int index) {
    if (state.listAnswersStatus[index] == 'none') {
      return Colors.black;
    } else if (state.listAnswersStatus[index] == 'true') {
      return AppColor.white;
    } else if (state.listAnswersStatus[index] == 'false') {
      return AppColor.white;
    } else {
      return Colors.black;
    }
  }
}
