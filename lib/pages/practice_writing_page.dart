import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_practice_writing_cubit/kanji_practice_writing_cubit.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/features/kanji/practice_writing/drawing_room.dart';
import 'package:untitled/widgets/loading_progress.dart';

import '../configs/app_color.dart';
import '../enums/app_text.dart';
import '../features/kanji/practice_writing/custom_paint_kanji.dart';
import '../models/kanji.dart';
import '../widgets/app_bar_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PracticeWritingPage extends StatelessWidget {
  const PracticeWritingPage({Key? key, required this.kanji}) : super(key: key);
  final Kanji kanji;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final cubit = KanjiPracticeWritingCubit();
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarCustom(
          title: AppTextTranslate.getTranslatedText(
              EnumAppText.txtPracticeWriting),
          bgColor: AppColor.blue,
          textColor: AppColor.white,
        ),
      ),
      body: BlocProvider(
          create: (context) => cubit..loadKanji(kanji),
          child:
              BlocBuilder<KanjiPracticeWritingCubit, KanjiPracticeWritingState>(
            builder: (context, state) {
              if (state is KanjiPracticeWritingLoaded) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20).copyWith(bottom: 50),
                      height: size.height * 0.8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColor.whiteAccent1.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Expanded(
                              flex: 3,
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 200,
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Stack(
                                          children: [
                                            Opacity(
                                              opacity:
                                              !state.isHideCoordinates
                                                  ? 1
                                                  : 0,
                                              child: CustomPaint(
                                                painter: CustomPaintKanji(
                                                    stringPath: state.kanji.path),
                                              ),
                                            ),
                                            Align(
                                                child: Container(
                                              height: 0.5,
                                              color: Colors.black54,
                                              width: 140,
                                            )),
                                            Align(
                                                child: Container(
                                              height: 140,
                                              color: Colors.black54,
                                              width: 0.5,
                                            ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Expanded(
                              child: Text(
                            state.kanji.vi,
                            style: AppStyle.kTitle.copyWith(fontSize: 25),
                          ))
                        ],
                      ),
                    ),
                    DrawingRoom(kanji: state.kanji , state: state,)
                  ],
                );
              }
              return const LoadingProgress();
            },
          )),
    );
  }
}
