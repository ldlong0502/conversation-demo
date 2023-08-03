import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_multiple_choice_cubit/kanji_multiple_choice_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/kanji/multiple_choice/result_header.dart';
class ResultBody extends StatelessWidget {
  const ResultBody({Key? key, required this.state}) : super(key: key);
  final KanjiMultipleChoiceLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<KanjiMultipleChoiceCubit>();
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColor.white,
              automaticallyImplyLeading: false,
              elevation: 0,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.blurBackground],
                  background: ResultHeader(state: state,)),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 5, right: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColor.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 3.0),
                              spreadRadius: 1,
                              blurRadius: 4.0,
                            ),
                          ],
                          border:
                          Border.all(color: AppColor.blue, width: 0.5)),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              '${index + 1}.${state.historyAnswers[index]['title']}',
                              maxLines: 1,
                              style: AppStyle.kTitle.copyWith(
                                  color: state.historyAnswers[index]['answer']
                                      ? Colors.black
                                      : Colors.redAccent,
                                  fontSize: 18),
                            )),
                      ),
                    ),
                  );
                },
                childCount: state.historyAnswers.length,
              ),
              
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 50))
          ],
        ),
        Positioned(
            bottom: 0,
            left: 30,
            right: 30,
            height: 40,
            child: GestureDetector(
              onTap: () {
               cubit.onDoAgain();
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColor.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    )),
                child: Center(
                  child: Text(
                    AppTextTranslate.getTranslatedText(EnumAppText.txtDoAgain),
                    style: AppStyle.kTitle.copyWith(color: AppColor.white),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
