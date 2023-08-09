import 'package:flutter/material.dart';
import 'package:untitled/blocs/word_practice_cubit/word_practice_cubit.dart';
import 'package:untitled/widgets/loading_progress.dart';
import '../../configs/app_color.dart';
import '../../configs/app_style.dart';
import '../../enums/app_text.dart';
import '../../features/word/practice/word_practice_grid_answer.dart';
import '../../features/word/practice/word_practice_slider.dart';
import '../../models/word.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/alert_dialog_result.dart';
import '../../widgets/app_bar_custom_sound.dart';

class WordPracticePage extends StatelessWidget {
  const WordPracticePage({Key? key, required this.listWord}) : super(key: key);
  final List<Word> listWord;
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height - kToolbarHeight;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarCustomSound(
          title: AppTextTranslate.getTranslatedText(EnumAppText.txtPractice),
          bgColor: AppColor.orange,
          textColor: AppColor.white,
        ),
      ),
      body: BlocProvider(
        create: (context) => WordPracticeCubit()..getData(listWord),
        child: BlocBuilder<WordPracticeCubit, WordPracticeState>(
          builder: (context, state) {
            if(state is WordPracticeLoaded) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: WordPracticeSlider(state: state,),
                        ),
                        Text(
                          state.listQuestion[state.indexCurrent].word,
                          textAlign: TextAlign.center,
                          style: AppStyle.kTitle.copyWith(
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          '/${state.listQuestion[state.indexCurrent].phonetic}/',
                          textAlign: TextAlign.center,
                          style: AppStyle.kSubTitle.copyWith(
                              fontSize: 20,
                              color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 20,),
                        WordPracticeGridAnswer(state: state,),
                        const SizedBox(height: 20,),
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
                  AlertDialogResult(
                      isWrongResult: state.indexCurrent + 1 != state.listQuestion.length,
                      onDoAgain: (){
                        context.read<WordPracticeCubit>().onDoAgain();
                      },
                      isShowingDialog:  state.isShowingDialog)
                ],

              );
            }
            return const LoadingProgress();
          },
        )

      )
    );
  }
}
