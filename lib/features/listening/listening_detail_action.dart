import 'package:flutter/material.dart';
import 'package:untitled/blocs/listening_effect_cubit/listening_effect_cubit.dart';
import 'package:untitled/features/listening/circle_button_effect.dart';

import '../../configs/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ListeningDetailAction extends StatelessWidget {
  const ListeningDetailAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectCubit = context.watch<ListeningEffectCubit>().state as ListeningEffectLoaded;
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleButtonEffect(
          icon: Icons.closed_caption_off_rounded,
          color: effectCubit.isBlur ? AppColor.blue : AppColor.grey,
          index: 1,
        ),
        CircleButtonEffect(
            icon: Icons.translate_outlined,
            color: effectCubit.isTranslate ? AppColor.blue : AppColor.grey,
            index: 2
        ),
        CircleButtonEffect(
            icon: Icons.spellcheck_sharp,
            color: effectCubit.isPhonetic ? AppColor.blue : AppColor.grey,
            index: 3
        ),
        CircleButtonEffect(
            icon: Icons.speed_outlined,
            color: effectCubit.isSpeed ? AppColor.blue : AppColor.grey,
            index: 4
        ),
      ],
    );
  }
}
