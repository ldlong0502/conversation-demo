import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:untitled/models/kanji.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../utils/split_text.dart';

class BackItem extends StatelessWidget {
  const BackItem({Key? key, required this.item}) : super(key: key);
  final Kanji item;
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          width: double.infinity,
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
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(item.kanji , style: AppStyle.kTitle.copyWith(
                          fontSize: 50
                      ),),
                      AutoSizeText(item.vi , style: AppStyle.kTitle.copyWith(
                          fontSize: 20
                      ),),
                    ],
                  )

              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(

                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: SplitText().extractRhythmKanji(item.kunyomi).map((e) => Text(e , style: AppStyle.kTitle.copyWith(
                                fontSize: 20
                            ),)).toList(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: SplitText().extractRhythmKanji(item.onyomi).map((e) => Text(e ,style: AppStyle.kTitle.copyWith(
                                fontSize: 20
                            ),)).toList(),
                          ),
                        )
                      ],
                    ),
                  )

              ),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            right: 5,
            width: 130,
            height: 40,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColor.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)
                  )
              ),
              child: Center(
                child: AutoSizeText(AppTextTranslate.getTranslatedText(EnumAppText.txtFlipFront),
                  style: AppStyle.kTitle.copyWith(
                      color: AppColor.white,
                      fontSize: 12
                  ),),
              ),
            ))
      ],
    );
  }
}
