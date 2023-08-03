import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:untitled/configs/app_style.dart';

import '../../../blocs/kanji_multiple_choice_cubit/kanji_multiple_choice_cubit.dart';
import '../../../configs/app_color.dart';

class ResultHeader extends StatelessWidget {
  const ResultHeader({Key? key, required this.state}) : super(key: key);
  final KanjiMultipleChoiceLoaded state;
  @override
  Widget build(BuildContext context) {
    final answerRight =
        state.historyAnswers.where((e) => e['answer']).toList().length;
    final res = (answerRight * 100 / state.listChoices.length).round();
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'Kết quả',
          style: AppStyle.kTitle.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(0.0, 3.0),
                            spreadRadius: 4,
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('$res%'),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: CircularPercentIndicator(
                    lineWidth: 10.0,
                    animationDuration: 2000,
                    percent: (res / 100).toDouble(),
                    animation: true,
                    backgroundColor: Colors.transparent,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColor.blue,
                    radius: 60,
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
