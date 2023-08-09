
import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/features/word/word_float_navigate_button.dart';
import 'package:untitled/widgets/loading_progress.dart';
import '../../blocs/word_flashcard_cubit/word_flashcard_cubit.dart';
import '../../enums/app_text.dart';
import '../../features/word/flashcard/word_flashcard_item.dart';
import '../../models/word.dart';
import '../../widgets/app_bar_custom.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordFlashCardPage extends StatefulWidget {
  const WordFlashCardPage({Key? key, required this.listWord}) : super(key: key);
  final List<Word> listWord;

  @override
  State<WordFlashCardPage> createState() => _WordFlashCardPageState();
}

class _WordFlashCardPageState extends State<WordFlashCardPage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int index = 0;
  var listItems = <Word>[];
  List<GlobalKey<PageFlipBuilderState>> listPageFlipKey = [];

  @override
  void initState() {
    listItems = List.of(widget.listWord);
    listItems.shuffle();
    for (var i in listItems) {
      final pageFlipKey = GlobalKey<PageFlipBuilderState>();
      listPageFlipKey.add(pageFlipKey);
    }

    _pageController.addListener(() {
      setState(() {
        index = _pageController.page!.toInt();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteAccent2,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarCustom(
              title:
              AppTextTranslate.getTranslatedText(EnumAppText.txtFlashcard),
              bgColor: AppColor.orange,
              textColor: AppColor.white,
            ),
          ),
          body: BlocProvider(
            create: (context) => WordFlashcardCubit()..getData(listItems),
            child: BlocBuilder<WordFlashcardCubit, WordFlashcardState>(
              builder: (context, state) {
                if(state is WordFlashcardLoaded) {
                  return Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.75,
                        child: PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            controller: _pageController,
                            itemCount: state.listItems.length,
                            itemBuilder: (context, idx) {
                              return WordFlashcardItem(
                                  item: state.listItems[idx],
                                  pageKey: listPageFlipKey[idx]);
                            }),
                      ),
                    ],
                  );
                }
                return const LoadingProgress();
              },
            ),
          ),
        ),
        WordFloatNavigateButton(
            index: index,
            max: listItems.length,
            onPrevious: () async {
              final previousIndex =
              index - 1 < 0 ? listItems.length - 1 : index - 1;
              _pageController.animateToPage(previousIndex,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut);
            },
            onNext: () async {
              final nextIndex = index + 1 >= listItems.length ? 0 : index + 1;
              _pageController.animateToPage(nextIndex,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut);
            })
      ],
    );
  }
}
