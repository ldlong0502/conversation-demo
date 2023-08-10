import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import '../../../models/word.dart';
import '../../../repositories/word_repository.dart';
import '../../../services/sound_service.dart';
import '../word_example_mean_text.dart';
import '../word_example_text.dart';

class WordFlashCardBackItem extends StatelessWidget {
  const WordFlashCardBackItem({Key? key, required this.item}) : super(key: key);
  final Word item;
  @override
  Widget build(BuildContext context) {
    final repo =  WordRepository.instance;
    return  Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5 , vertical: 20),
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                item.word,
                style: AppStyle.kTitle
                    .copyWith(color: Colors.orange, fontSize: 30),
              ),
              Text(
                '/${item.phonetic}/',
                style: AppStyle.kTitle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontStyle: FontStyle.italic),
              ),

              Text(
                item.mean,
                style: AppStyle.kTitle.copyWith(fontSize: 30),
              ),

              GestureDetector(
                onTap: () async {
                  String path = repo.getUrlAudioById(item.id.toString());

                  if (File(path).existsSync()) {
                    await SoundService.instance.playSound(path);
                  }
                },
                child: Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.2),
                          offset: const Offset(0.0, 3.0),
                          spreadRadius: 4,
                          blurRadius: 4.0,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.volume_down_sharp,
                      color: AppColor.white,
                      size: 50,
                    )),
              ),

              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: WordExampleText(example: item.example),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: WordExampleMeanText(
                    exampleMean: item.example_mean),
              ),
              const SizedBox(height: 60,),
            ],
          )
        ),
        Positioned(
            bottom: 20,
            right: 5,
            width: 130,
            height: 40,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColor.orange,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)
                  )
              ),
              child: Center(
                child: Text(AppTextTranslate.getTranslatedText(EnumAppText.txtFlipFront),
                  style: AppStyle.kTitle.copyWith(
                      color: AppColor.white,
                      fontSize: 12
                  ),)
              ),
            ))
      ],
    );
  }
}
