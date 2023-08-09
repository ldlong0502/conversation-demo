import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/blocs/word_flashcard_cubit/word_flashcard_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import '../../../models/word.dart';
import '../../../repositories/word_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordFlashCardFrontItem extends StatelessWidget {
  const WordFlashCardFrontItem({Key? key, required this.item})
      : super(key: key);
  final Word item;

  @override
  Widget build(BuildContext context) {
    final repo = WordRepository.instance;
    final cubitFlashcard = context.watch<WordFlashcardCubit>();
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      cubitFlashcard.highLightFlashcard(item);
                    },
                    icon: (cubitFlashcard.state as WordFlashcardLoaded)
                            .listIdHighLight
                            .contains(item.id.toString())
                        ? const Icon(
                            Icons.star_rounded,
                            size: 35,
                            color: AppColor.orange,
                          )
                        : const Icon(
                            Icons.star_border_rounded,
                            size: 35,
                          ),
                  ),
                ),
              ),
              Text(
                item.word,
                style: AppStyle.kTitle
                    .copyWith(color: Colors.orange, fontSize: 30),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                  child: Image.file(
                File(repo.getUrlImageById(item.id)),
                height: 150,
              )),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            left: 5,
            width: 130,
            height: 40,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColor.orange,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              child: Center(
                child: Text(
                  AppTextTranslate.getTranslatedText(EnumAppText.txtFlipBehind),
                  style: AppStyle.kTitle
                      .copyWith(color: AppColor.white, fontSize: 12),
                ),
              ),
            ))
      ],
    );
  }
}
