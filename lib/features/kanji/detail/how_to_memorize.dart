import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_cubit/kanji_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/kanji/detail/corner_title.dart';
import 'package:untitled/repositories/kanji_repository.dart';
import 'package:untitled/widgets/loading_progress.dart';
import '../../../enums/app_text.dart';
import '../../../models/kanji.dart';

class HowToMemorize extends StatelessWidget {
  const HowToMemorize({Key? key, required this.kanji}) : super(key: key);
  final Kanji kanji;

  @override
  Widget build(BuildContext context) {
    final repo = KanjiRepository.instance;
    final path = repo.getUrlImageById('lal${kanji.id}');
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
             Column(
                children: [
                  const SizedBox(height: 20,),
                  Expanded(
                      flex: 2,
                      child: Align(
                          alignment: Alignment.center,
                          child: Image.file(
                            File(path),
                            errorBuilder: (context, error, stackTrace) =>
                                Text('Not found', style: AppStyle.kTitle.copyWith(color: AppColor.white),),))),
                  Expanded(
                      child:
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(kanji.lookAndLearn,
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
