import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/blocs/word_cubit/list_word_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/models/word.dart';
import 'package:untitled/routes/app_routes.dart';
import 'package:untitled/services/sound_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/word_repository.dart';
class WordItem extends StatelessWidget {
  const WordItem({Key? key, required this.word}) : super(key: key);
  final Word word;

  @override
  Widget build(BuildContext context) {
    final listWordCubit = context.read<ListWordCubit>();
    final repo =  WordRepository.instance;
    return InkWell(
      onTap: () async {
        listWordCubit.updateWord(word);
        Navigator.pushNamed(context, AppRoutes.wordDetail, arguments: {
          'listWordCubit': listWordCubit
        });
      },
      borderRadius:  BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
              height: 170,
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                  color: AppColor.white,
                  border: Border.all(color: AppColor.orange, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0.0, 3.0),
                      spreadRadius: 4,
                      blurRadius: 4.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(20)),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Image.file(File(repo.getUrlImageById(word.id.toString())))
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(word.word , style: AppStyle.kTitle.copyWith(
                            color: Colors.orange,
                            fontSize: 25
                          ),),
                          Text('/${word.phonetic}/' ,style: AppStyle.kTitle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                            fontStyle: FontStyle.italic
                          ),),
                          GestureDetector(
                            onTap: () async {
                              String path =repo.getUrlAudioById(word.id.toString());

                              if(File(path).existsSync()) {
                                await SoundService.instance.playSound(path);
                              }
                            },
                            child: Container(
                              height: 35,
                                width: 35,
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
                                child: const Icon(Icons.volume_down_sharp , color: AppColor.white,)),
                          ),
                          Text(word.mean , style: AppStyle.kTitle.copyWith(
                              fontSize: 18
                          ),),

                        ],
                      ),
                    ),
                    const SizedBox(width: 45,)
                  ],
                ),
              )),
          Positioned(
              bottom: 3,
              right: 0,
              width: 45,
              height: 35,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  )
                ),
                child: const Center(
                  child: Icon(Icons.arrow_forward , color: AppColor.white,),
                ),
              ))
        ],
      ),
    );
  }
}
