import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:untitled/blocs/kanji_multiple_choice_cubit/kanji_multiple_choice_cubit.dart';
import 'package:untitled/configs/app_style.dart';
class ProgressHeader extends StatelessWidget {
  const ProgressHeader({Key? key, required this.state}) : super(key: key);
  final KanjiMultipleChoiceLoaded state;
  @override
  Widget build(BuildContext context) {
    final answerRight =
        state.historyAnswers.where((e) => e['answer']).toList().length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${state.indexCurrent + 1}/${state.listChoices.length}',
          style: AppStyle.kTitle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              LinearPercentIndicator(
                animation: true,
                lineHeight: 10.0,
                animationDuration: 0,
                percent: (state.indexCurrent + 1) / state.listChoices.length,
                barRadius: const Radius.circular(20.0),
                progressColor: Colors.green.withOpacity(0.5),
              ),
              LinearPercentIndicator(
                animation: true,
                lineHeight: 7.0,
                backgroundColor: Colors.transparent,
                animationDuration: 0,
                percent: answerRight / state.listChoices.length,
                barRadius: const Radius.circular(15.0),
                progressColor: Colors.brown,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
