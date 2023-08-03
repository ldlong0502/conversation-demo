import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/features/kanji/flashcard/flashcard_item.dart';

import '../enums/app_text.dart';
import '../models/kanji.dart';
import '../widgets/app_bar_custom.dart';
import 'package:page_flip_builder/page_flip_builder.dart';

import '../widgets/float_navigate_button.dart';
class FlashCardPage extends StatefulWidget {
  const FlashCardPage({Key? key, required this.listKanjis}) : super(key: key);
  final List<Kanji> listKanjis;
  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int index = 0;
  var listItems = <Kanji>[];
  List<GlobalKey<PageFlipBuilderState>> listPageFlipKey = [];

  @override
  void initState() {
    listItems = List.of(widget.listKanjis);
    listItems.shuffle();
    for(var i in listItems) {
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
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteAccent2,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarCustom(
              title: AppTextTranslate.getTranslatedText(EnumAppText.txtFlashcard),
              bgColor: AppColor.blue,
              textColor: AppColor.white,
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: size.height * 0.75,
                child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    itemCount: listItems.length,
                    itemBuilder: (context, idx) {
                      return FlashcardItem(item: listItems[idx] ,pageKey: listPageFlipKey[idx] );
                    }),
              ),
            ],
          ),
        ),
        FloatNavigateButton(
            index: index,
            max: listItems.length,
            onPrevious: () async {
              final previousIndex =
              index - 1 < 0 ? listItems.length - 1 : index - 1;
              _pageController.animateToPage(previousIndex, duration:const Duration(milliseconds: 1000), curve: Curves.easeOut);
            },
            onNext: () async {
              final nextIndex = index + 1 >= listItems.length ? 0 : index + 1;
              _pageController.animateToPage(nextIndex, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
            })
      ],
    );
  }
}
