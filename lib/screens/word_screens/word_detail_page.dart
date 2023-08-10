import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/blocs/word_cubit/list_word_cubit.dart';
import '../../configs/app_color.dart';
import '../../configs/app_style.dart';
import '../../enums/app_text.dart';
import '../../features/word/word_example_mean_text.dart';
import '../../features/word/word_example_text.dart';
import '../../features/word/word_float_navigate_button.dart';
import '../../repositories/word_repository.dart';
import '../../services/sound_service.dart';
import '../../widgets/app_bar_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/loading_progress.dart';

class WordDetailPage extends StatelessWidget {
  const WordDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = WordRepository.instance;
    var wordCubit = context.watch<ListWordCubit>().state as ListWordLoaded;
    final index = wordCubit.listWord
        .indexWhere((element) => element.id == wordCubit.word.id);
    final max = wordCubit.listWord.length;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarCustom(
              title: AppTextTranslate.getTranslatedText(EnumAppText.txtDetail),
              bgColor: AppColor.orange,
              textColor: AppColor.white,
            ),
          ),
          body: BlocBuilder<ListWordCubit, ListWordState>(
            builder: (context, state) {
              if (state is ListWordLoaded) {
                final path = repo.getUrlImageById(state.word.id.toString());
                debugPrint('=>>>>>>$path}');
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Expanded(
                              flex: 2,
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColor.grey)),
                                child: Center(
                                  child: Image.file(
                                    File(path),
                                    height: 120,
                                  ),
                                ),
                              )),
                          Expanded(child: Container()),
                        ],
                      ),
                      Text(
                        state.word.word,
                        style: AppStyle.kTitle
                            .copyWith(color: Colors.orange, fontSize: 30),
                      ),
                      Text(
                        '/${state.word.phonetic}/',
                        style: AppStyle.kTitle.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                      GestureDetector(
                        onTap: () async {
                          String path = repo.getUrlAudioById(state.word.id.toString());

                          if (File(path).existsSync()) {
                            await SoundService.instance.playSound(path);
                          }
                        },
                        child: Container(
                            height: 80,
                            width: 80,
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
                      Text(
                        state.word.mean,
                        style: AppStyle.kTitle.copyWith(fontSize: 30),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: WordExampleText(example: state.word.example),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: WordExampleMeanText(
                            exampleMean: state.word.example_mean),
                      ),
                      const SizedBox(height: 60,),
                    ],
                  ),
                );
              }
              return const LoadingProgress();
            },
          ),
        ),
        WordFloatNavigateButton(
            index: index,
            max: max,
            onPrevious: () {
              var cubit = context.read<ListWordCubit>();
              final preIndex = index - 1 < 0 ? max -1 : index - 1;
              cubit.updateWord(wordCubit.listWord[preIndex]);
            },
            onNext: () {
              var cubit = context.read<ListWordCubit>();
              final nextIndex = index + 1 == max ? 0 : index + 1;
              cubit.updateWord(wordCubit.listWord[nextIndex]);
            })
      ],
    );
  }
}
