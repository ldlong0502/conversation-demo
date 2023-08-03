import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_player_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';

import '../../configs/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SliderBar extends StatelessWidget {
  const SliderBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consCubit = context.watch<ConversationPlayerCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () async {
           if(consCubit.state!.isPlaying) {
             consCubit.pause();
           } else{
             consCubit.play();
           }
          },
          child: Container(
            height: 25,
            width: 25,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration:  BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0.0, 3.0),
                    spreadRadius: 2,
                    blurRadius: 4.0,
                  ),
                ],
                color: AppColor.blue),
            alignment: Alignment.center,
            child: Icon(consCubit.state!.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white, size: 20),
          ),
        ),
        Flexible(
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight: 0.5,
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
            ),
            child: Slider(
              value: consCubit.state!.durationCurrent.inMilliseconds.toDouble(),
              min: 0,
              max: consCubit.state!.durationMax.inMilliseconds.toDouble(),
              thumbColor: AppColor.blue,
              activeColor: AppColor.blue,
              onChanged: (value) {
                consCubit.onChanged(value);
              },
            ),
          ),
        ),
        const SizedBox(width: 20,)
      ],
    );
  }
}
