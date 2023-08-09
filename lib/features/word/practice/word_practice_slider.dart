import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/blocs/word_practice_cubit/word_practice_cubit.dart';
import '../../../configs/app_color.dart';

class WordPracticeSlider extends StatefulWidget {
  const WordPracticeSlider({Key? key, required this.state}) : super(key: key);
  final WordPracticeLoaded state;

  @override
  State<WordPracticeSlider> createState() => _WordPracticeSliderState();
}

class _WordPracticeSliderState extends State<WordPracticeSlider> {

  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer  = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      context.read<WordPracticeCubit>().countTimer();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text('${widget.state.indexCurrent + 1}/${widget.state.listQuestion.length}'),
          Expanded(
            child: LinearPercentIndicator(
              animation: true,
              animateFromLastPercent: true,
              isRTL: true,
              lineHeight: 10.0,
              animationDuration: 0,
              percent:  widget.state.startTime / 5,
              barRadius: const Radius.circular(20.0),
              progressColor: AppColor.green,
            ),
          ),
          Row(
              children: widget.state.listHeart
                  .map((e) => Icon(
                Icons.favorite,
                color: e ? AppColor.red : AppColor.old,
              ))
                  .toList())
        ],
      ),
    );
  }
}
