import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/blocs/kanji_cubit/kanji_cubit.dart';
import 'package:untitled/blocs/list_kanji_cubit/list_kanji_cubit.dart';
import 'package:untitled/features/kanji/detail/how_to_memorize.dart';
import 'package:untitled/features/kanji/detail/kunyomi_list.dart';
import 'package:untitled/features/kanji/detail/radical_list.dart';
import 'package:untitled/features/kanji/detail/vocabulary_list.dart';
import 'package:untitled/widgets/float_navigate_button.dart';

import '../../blocs/kanji_voc_cubit/kanji_vocabulary_cubit.dart';
import '../../features/kanji/detail/header_detail_appbar.dart';
import '../../features/kanji/detail/onyomi_list.dart';
import '../../models/kanji.dart';
import '../../widgets/loading_progress.dart';

class KanjiDetailPage extends StatefulWidget{
  final Kanji kanji;

  const KanjiDetailPage(this.kanji, {Key? key}) : super(key: key);

  @override
  State<KanjiDetailPage> createState() => _KanjiDetailPageState();
}

class _KanjiDetailPageState extends State<KanjiDetailPage>  with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final kanjiCubit = KanjiCubit();
  final kanjiVocabularyCubit = KanjiVocabularyCubit();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final listKanjis = context.watch<ListKanjiCubit>().state!;

    return BlocProvider(
      lazy: false,
      create: (context) => kanjiCubit..updateKanji(widget.kanji),
      child: BlocBuilder<KanjiCubit, Kanji?>(
        builder: (context, state) {
          if (state == null) return const LoadingProgress();
          final index = listKanjis.indexWhere((element) => element.id == state.id);
          return SafeArea(
              child: Stack(
            children: [
              Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(180),
                  child: HeaderDetailAppbar(
                    kanji: state,
                    animationController: animationController,
                    onHighLight: () {
                      kanjiCubit.updateKanji(
                          state.copyWith(isHighLight: !state.isHighLight));
                      BlocProvider.of<ListKanjiCubit>(context)
                          .updateKanjiHighLight(state);
                    },
                  ),
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      HowToMemorize(kanji: state),
                      KunyomiList(kanji: state),
                      OnyomiList(kanji: state),
                      RadicalList(kanji: state),
                      VocabularyList(kanjiVocabularyCubit: kanjiVocabularyCubit),
                      const SizedBox(height: 100,)
                    ],
                  ),
                ),
              ),
              FloatNavigateButton(
                  index: index,
                  max: listKanjis.length,
                  onPrevious: () async {

                    final previousIndex = index - 1 < 0   ? listKanjis.length - 1 : index - 1;
                     kanjiCubit.updateKanji(listKanjis[previousIndex]);
                    animationController.forward(from: 0);
                    kanjiVocabularyCubit.updateKanji(listKanjis[previousIndex]);

                  },
                  onNext: () async {
                    final nextIndex = index + 1 >=  listKanjis.length ? 0 : index + 1;
                    kanjiCubit.updateKanji(listKanjis[nextIndex]);
                    animationController.forward(from: 0);
                    kanjiVocabularyCubit.updateKanji(listKanjis[nextIndex]);

                  })
            ],
          ));
        },
      ),
    );
  }
}
