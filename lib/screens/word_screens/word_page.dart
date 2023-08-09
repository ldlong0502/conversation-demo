import 'package:flutter/material.dart';
import '../../blocs/word_cubit/list_word_cubit.dart';
import '../../configs/app_color.dart';
import '../../enums/app_text.dart';
import '../../features/word/float_button_feature_word.dart';
import '../../features/word/list_view_word.dart';
import '../../repositories/download_repository.dart';
import '../../widgets/app_bar_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/loading_progress.dart';
class WordPage extends StatelessWidget {
  const WordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DownloadRepository.instance.setContext(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarCustom(
          title: AppTextTranslate.getTranslatedText(EnumAppText.txtVocabulary),
          bgColor: AppColor.orange,
          textColor: AppColor.white,
        ),
      ),
      body: BlocProvider(
        create: (context) => ListWordCubit()..getData(),
        child: BlocBuilder<ListWordCubit, ListWordState>(
            builder: (context, state) {
              if (state is ListWordLoaded) {
                return Stack(
                  children: [
                    ListViewWord(listWord: state.listWord,),
                    const FloatActionFeatureWord()
                  ],
                );
              }
              return const LoadingProgress();
            }
        ),
      ),
    );
  }
}
