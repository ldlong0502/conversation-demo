
import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/features/kanji/detail/furigana_column_text.dart';
import 'package:untitled/models/vocabulary_kanji.dart';
import 'package:untitled/repositories/kanji_repository.dart';
import '../../../services/sound_service.dart';

class VocabularyItem extends StatelessWidget {
  const VocabularyItem({Key? key, required this.vocabulary}) : super(key: key);
  final VocabularyKanji vocabulary;
  @override
  Widget build(BuildContext context) {
    final soundService = SoundService.instance;
    final repo = KanjiRepository.instance;
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                final path =  repo.getUrlAudioById(vocabulary.id.toString());
                soundService.playSound(path);
              },
              child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.white,
                    border: Border.all(color: AppColor.blue),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0.0, 3.0),
                        spreadRadius: 4,
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: const Center(
                    child:  Icon(
                      Icons.volume_down_rounded,
                      size: 25,
                      color: AppColor.blue,
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              flex: 4, child: FuriganaColumnText(vocabulary: vocabulary,)),
          Expanded(
              flex: 4,
              child: Text(
                vocabulary.mean,
                style: AppStyle.kTitle,
                maxLines: 2,
              )),
        ],
      ),
    );
  }
}
