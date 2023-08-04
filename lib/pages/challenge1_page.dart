import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_challenge1_cubit/kanji_challenge1_cubit.dart';
import 'package:untitled/features/kanji/challenge1/alert_notify_challenge.dart';
import 'package:untitled/features/kanji/challenge1/appbar_challenge1.dart';
import 'package:untitled/features/kanji/challenge1/grid_answer.dart';
import 'package:untitled/features/kanji/challenge1/progress_header.dart';
import 'package:untitled/widgets/loading_progress.dart';

import '../configs/app_color.dart';
import '../configs/app_style.dart';
import '../enums/app_text.dart';
import '../models/kanji.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/app_bar_custom.dart';

class Challenge1Page extends StatelessWidget {
  const Challenge1Page({Key? key, required this.listKanjis}) : super(key: key);
  final List<Kanji> listKanjis;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).size.height - kToolbarHeight;
    final cubit = KanjiChallenge1Cubit();
    return BlocProvider(
        create: (context) => cubit..getData(listKanjis),
        child: BlocBuilder<KanjiChallenge1Cubit, KanjiChallenge1State>(
            builder: (context, state) {
          if (state is KanjiChallenge1Loaded) {
            return Scaffold(
              backgroundColor: AppColor.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AppBarChallenge1(
                  title: AppTextTranslate.getTranslatedText(EnumAppText.txtChallenge1),
                  bgColor: AppColor.blue,
                  textColor: AppColor.white,
                  state: state,
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ProgressHeader(state: state,),
                        ),
                        Container(
                          height: height * 0.7,
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: AppColor.whiteAccent2,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                  state.listQuestion[state.indexCurrent].vi,
                                  textAlign: TextAlign.center,
                                  style: AppStyle.kTitle.copyWith(
                                    color: AppColor.green,
                                    fontSize: 30,
                                  ),
                                ),
                              )),
                              Expanded(flex: 4, child: GridAnswer(state: state,))
                            ],
                          ),
                        ),
                        Text(
                          '${state.indexCurrent + 1}/${state.listQuestion.length}',
                          style: AppStyle.kTitle.copyWith(color: AppColor.green),
                        )
                      ],
                    ),
                  ),
                  if (state.isShowingDialog)
                    GestureDetector(
                      onTap: () {},
                      child: Opacity(
                        opacity: 0.8, // Độ mờ của lớp
                        child: Container(
                          color: AppColor.white, // Màu của lớp mờ
                        ),
                      ),
                    ),
                  AlertNotifyChallenge(state: state)
                ],
              ),
            );
          }
          return  Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarCustom(
                title: AppTextTranslate.getTranslatedText(EnumAppText.txtChallenge1),
                bgColor: AppColor.blue,
                textColor: AppColor.white,
              ),
            ),
            body: const LoadingProgress(),
          );
        }));
  }
}
