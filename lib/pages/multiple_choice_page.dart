import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_multiple_choice_cubit/kanji_multiple_choice_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/features/kanji/multiple_choice/appbar_multiple_choice.dart';
import 'package:untitled/features/kanji/multiple_choice/body_question.dart';
import 'package:untitled/features/kanji/multiple_choice/result_body.dart';
import 'package:untitled/widgets/loading_progress.dart';

import '../enums/app_text.dart';
import '../features/kanji/multiple_choice/progress_header.dart';
import '../widgets/app_bar_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultipleChoicePage extends StatelessWidget {
  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = KanjiMultipleChoiceCubit();
    return BlocProvider(
      create: (context) => cubit..getData(),
      child: BlocBuilder<KanjiMultipleChoiceCubit, KanjiMultipleChoiceState>(
        builder: (context, state) {
          if (state is KanjiMultipleChoiceLoaded) {
            return Scaffold(
                backgroundColor: AppColor.white,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: AppBarMultipleChoice(
                    title: AppTextTranslate.getTranslatedText(
                        EnumAppText.txtMultipleChoice),
                    bgColor: AppColor.blue,
                    textColor: AppColor.white,
                    state: state,
                  ),
                ),
                body: state.isShowResult
                    ? ResultBody(state: state)
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ProgressHeader(state: state),
                            ),
                            BodyQuestion(state: state)
                          ],
                        ),
                      ));
          }
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarCustom(
                title: AppTextTranslate.getTranslatedText(
                    EnumAppText.txtMultipleChoice),
                bgColor: AppColor.blue,
                textColor: AppColor.white,
              ),
            ),
            body: const LoadingProgress(),
          );
        },
      ),
    );
  }
}
