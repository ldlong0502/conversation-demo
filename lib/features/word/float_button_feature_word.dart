import 'package:flutter/material.dart';
import 'package:untitled/blocs/word_cubit/list_word_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:untitled/features/word/feature_item.dart';
import 'package:untitled/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class FloatActionFeatureWord extends StatelessWidget {
  const FloatActionFeatureWord({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Positioned(
      bottom: 10,
      left: size.width * 0.1,
      right:  size.width * 0.1,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.orange
        ),
        child: Row(
          children: [
            Expanded(child: FeatureItem(
              title: AppTextTranslate.getTranslatedText(EnumAppText.txtFlashcard),
              asset: 'assets/images/ic_word_flashcard.png',
              onPress: () {
                final cubit = context.read<ListWordCubit>();
                    Navigator.pushNamed(context, AppRoutes.wordFlashcard , arguments:
                    {
                      'listWordCubit' : cubit,
                      'listWord': (cubit.state as ListWordLoaded).listWord
                    });
              },
            )),

            const VerticalDivider(
              width: 2,
              color: Colors.black,
              indent: 30,
              endIndent: 30,
            ),
            Expanded(child: FeatureItem(
              title: AppTextTranslate.getTranslatedText(EnumAppText.txtPractice),
              asset: 'assets/images/ic_word_practice.png',
              onPress: () {
                final cubit = context.read<ListWordCubit>();
                Navigator.pushNamed(context, AppRoutes.wordPractice , arguments:
                {
                  'listWordCubit' : cubit,
                  'listWord': (cubit.state as ListWordLoaded).listWord
                });
              },
            )),
            const VerticalDivider(
              width: 2,
              color: Colors.black,
              indent: 30,
              endIndent: 30,
            ),
            Expanded(child: FeatureItem(
              title: AppTextTranslate.getTranslatedText(EnumAppText.txtChallenge),
              asset: 'assets/images/ic_word_challenge.png',
              onPress: () {

              },
            )),
          ],
        ),
      ),
    );
  }
}
