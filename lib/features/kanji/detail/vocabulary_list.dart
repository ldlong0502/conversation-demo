import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_cubit/kanji_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/kanji/detail/vocabulary_item.dart';
import 'package:untitled/models/vocabulary.dart';
import 'package:untitled/widgets/loading_progress.dart';
import 'package:just_audio/just_audio.dart';
import '../../../blocs/kanji_voc_cubit/kanji_vocabulary_cubit.dart';
import '../../../enums/app_text.dart';
import 'corner_title.dart';

class VocabularyList extends StatelessWidget {
  const VocabularyList({Key? key, required this.kanjiVocabularyCubit})
      : super(key: key);
  final KanjiVocabularyCubit kanjiVocabularyCubit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<KanjiCubit>();

    final audioPlayer = AudioPlayer();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
          .copyWith(bottom: 15),
      decoration: BoxDecoration(
        color: AppColor.whiteAccent1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          BlocProvider(
            create: (context) =>
                kanjiVocabularyCubit..updateKanji(cubit.state!),
            child: BlocBuilder<KanjiVocabularyCubit, List<Vocabulary>?>(
              builder: (context, state) {
                if (state == null) return const LoadingProgress();
                return Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state!.length,
                        itemBuilder: (context, index) {
                          return VocabularyItem(
                              audioPlayer: audioPlayer,
                              vocabulary: state![index]);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          CornerTitle(
            title: AppTextTranslate.getTranslatedText(EnumAppText.txtVocabulary)
                .toUpperCase(),
            width: 100,
          )
        ],
      ),
    );
  }
}
