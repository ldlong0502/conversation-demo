import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_cubit/kanji_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/kanji/detail/corner_title.dart';
import 'package:untitled/widgets/loading_progress.dart';
import '../../../enums/app_text.dart';
import '../../../models/kanji.dart';

class HowToMemorize extends StatelessWidget {
  const HowToMemorize({Key? key, required this.kanji}) : super(key: key);
  final Kanji kanji;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<KanjiCubit>();
    cubit.getImageUsage(context);
    return Container(
        height: 150,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColor.whiteAccent1,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
            children: [
              cubit.state!.lookAndLearn == null
                  ? const LoadingProgress()
                  : Column(
                children: [
                  const SizedBox(height: 20,),
                  Expanded(
                      flex: 2,
                      child: Align(
                          alignment: Alignment.center,
                          child: Image.file(
                            File(cubit.state!.lookAndLearn!.imageUrl),
                            errorBuilder: (context, error, stackTrace) =>
                                Container(),))),
                  Expanded(
                      child:
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(cubit.state!.lookAndLearn!.vi,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: AppStyle.kTitle.copyWith(
                              fontSize: 12
                          ),),
                      ))
                ],),
              CornerTitle(title: AppTextTranslate.getTranslatedText(
                  EnumAppText.txtMemorize), width: 130,)
            ]
        )
      // ), _buildTitleUsageWidget()],
    );
  }
}
