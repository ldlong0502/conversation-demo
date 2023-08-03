import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/features/kanji/detail/corner_title.dart';

import '../../../enums/app_text.dart';
import '../../../models/kanji.dart';
import '../../../utils/split_text.dart';

class KunyomiList extends StatelessWidget {
  const KunyomiList({Key? key, required this.kanji}) : super(key: key);
  final Kanji kanji;
  @override
  Widget build(BuildContext context) {
    final listKun = SplitText().extractRhythmKanji(kanji.kunyomi);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
          .copyWith(bottom: 15),
      decoration: BoxDecoration(
        color: AppColor.whiteAccent1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 0)
                        .copyWith(left: 20),
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: listKun.map((e) {
                        return Container(
                            constraints: const BoxConstraints(
                                maxWidth: 100,
                                minWidth: 50,
                                minHeight: 20
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10 ,vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColor.blue,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Text(
                              e,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: AppStyle.kSubTitle.copyWith(
                                  fontSize: 10,
                                  color: AppColor.white),
                            ));
                      }).toList(),
                    ),
                  )),
            ],
          ),
          CornerTitle( title: AppTextTranslate.getTranslatedText(EnumAppText.txtKunyomi) ,width: 100,)
        ],
      ),
    );
  }
}
