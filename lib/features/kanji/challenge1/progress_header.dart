import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:untitled/blocs/kanji_challenge1_cubit/kanji_challenge1_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/app_color.dart';
class ProgressHeader extends StatefulWidget {
  const ProgressHeader({Key? key, required this.state}) : super(key: key);
  final KanjiChallenge1Loaded state;

  @override
  State<ProgressHeader> createState() => _ProgressHeaderState();
}

class _ProgressHeaderState extends State<ProgressHeader> {

  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer  = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      context.read<KanjiChallenge1Cubit>().countTimer();
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
