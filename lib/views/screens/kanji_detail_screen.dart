import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/blocs/bloc_kanji/kanji_bloc.dart';
import 'package:untitled/models/kanji.dart';
import 'package:untitled/models/vocabulary.dart';
import 'package:untitled/repositories/api_helper.dart';
import 'package:untitled/repositories/audio_helper.dart';
import 'package:untitled/repositories/kanji_repository.dart';
import 'package:untitled/utils/split_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../constants/constants.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:just_audio/just_audio.dart';
class KanjiDetailScreen extends StatefulWidget {
  const KanjiDetailScreen({Key? key}) : super(key: key);

  @override
  State<KanjiDetailScreen> createState() => _KanjiDetailScreenState();
}

class _KanjiDetailScreenState extends State<KanjiDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AudioPlayer audioplayer;

  @override
  void initState() {
    super.initState();
    audioplayer = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KanjiBloc, KanjiState>(builder: (context, state) {
      if (state is KanjiLoaded) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: kanjiColor2,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(180),
                child: headerTitle(context, state.kanjiCurrent, state),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildHowToMemorize(state),
                    _buildKunyomi(state.kanjiCurrent),
                    _buildOnyomi(state.kanjiCurrent),
                    _buildRadical(state.kanjiCurrent),
                    // _buildVocabularies(state.kanjiCurrent)
                    _buildVocabulary(state)
                  ],
                ),
              ),
            ),
            _buildFloatAction(state, context)
          ],
        );
      } else {
        return const Scaffold();
      }
    });
  }

  headerTitle(BuildContext context, Kanji kanji, KanjiLoaded state) {
    final listStringPath = SplitText().extractPathDataList(kanji.path);
    final paint = Paint()
      ..color = secondaryColor
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    var listPath = <Path>[];
    var listPaints = <Paint>[];
    for (var i in listStringPath) {
      listPath.add(parseSvgPathData(i));
      listPaints.add(paint);
    }

    return Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: secondaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0.0, 3.0),
              spreadRadius: 2,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: primaryColor,
                        )),
                  ),
                ),
                const Expanded(
                    flex: 3,
                    child: Center(
                        child: Text(
                      'Chi tiết',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ))),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.read<KanjiBloc>().add(const HighLightCurrentKanji());
                    },
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          !state.kanjiCurrent.isHighLight
                              ? 'assets/images/ic_idea_border.png'
                              : 'assets/images/ic_idea_fill.png',
                          height: 40,
                          color: primaryColor,
                        )),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!_animationController.isAnimating) {
                _animationController.forward(from: 0.0);
              }
            },
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: AnimatedDrawing.paths(
                      listPath,
                      paints: listPaints,
                      controller: _animationController,
                      run: _animationController.isAnimating,
                      duration: _animationController.duration,
                      onFinish: () {
                        _animationController.stop();
                      },
                    ),
                  ),
                  Text(
                    kanji.vi,
                    style: kTitle.copyWith(color: Colors.black, fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ]));
  }

  _buildHowToMemorize(KanjiLoaded state) {
   if(state.kanjiCurrent.lookAndLearn == null || state.kanjiCurrent.lookAndLearn!.imageUrl == '') {

     return Container(
       height: 40,
       width: double.infinity,
       margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
       decoration: BoxDecoration(
         color: kanjiColor1,
         borderRadius: BorderRadius.circular(25),
       ),
       child: Stack(
         children: [
           const Column(
             children: [

             ],
           ), _buildTitleUsageWidget()],
       ),
     );
   }
   else {
     return Container(
       height: 150,
       width: double.infinity,
       margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
       decoration: BoxDecoration(
         color: kanjiColor1,
         borderRadius: BorderRadius.circular(25),
       ),
       child: Stack(
         children: [
           Column(
           children: [
             const SizedBox(height: 20,),
              Expanded(
                flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                      child: Image.file(File(state.kanjiCurrent.lookAndLearn!.imageUrl)))),
             Expanded(
                 child:
                 Padding(
                   padding: EdgeInsets.symmetric(horizontal: 10),
                   child: Text(state.kanjiCurrent.lookAndLearn!.vi,
                     textAlign: TextAlign.center,
                     maxLines: 2,
                     style: kTitle.copyWith(
                       fontSize: 12
                     ),),
                 ))
           ],
         ), _buildTitleUsageWidget()],
       ),
     );
   }

  }

  _buildKunyomi(Kanji kanji) {
    final listKun = SplitText().extractRhythmKanji(kanji.kunyomi);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
          .copyWith(bottom: 15),
      decoration: BoxDecoration(
        color: kanjiColor1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0)
                            .copyWith(left: 20),
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: listKun.map((e) {
                        return Container(
                            constraints: const BoxConstraints(
                                maxWidth: 100,
                                minWidth: 50,
                                minHeight: 20
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 2),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Text(
                              e,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: kSubTitle.copyWith(
                                  fontSize: 10,
                                  color: primaryColor),
                            ));
                      }).toList(),
                    ),
                  )),
            ],
          ),
          _buildTitlePositionWidget('ÂM KUN')
        ],
      ),
    );
  }

  _buildOnyomi(Kanji kanji) {
    final listOn = SplitText().extractRhythmKanji(kanji.onyomi);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
          .copyWith(bottom: 15),
      decoration: BoxDecoration(
        color: kanjiColor1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0)
                            .copyWith(left: 20),
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: listOn.map((e) {
                        return Container(
                            constraints: const BoxConstraints(
                                maxWidth: 100,
                                minWidth: 50,
                                minHeight: 20
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 2),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Text(
                              e,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: kSubTitle.copyWith(
                                  fontSize: 10,
                                  color: primaryColor),
                            ));
                      }).toList(),
                    ),
                  )),
            ],
          ),
          _buildTitlePositionWidget('ÂM ON')
        ],
      ),
    );
  }

  _buildRadical(Kanji kanji) {
    final listRadical = SplitText().extractRhythmKanji(kanji.radical);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
          .copyWith(bottom: 15),
      decoration: BoxDecoration(
        color: kanjiColor1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0)
                            .copyWith(left: 20),
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: listRadical.map((e) {
                        return Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 100,
                                    minWidth: 50,
                                    minHeight: 20
                                  ),
                                    padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 2),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: const Offset(0.0, 2.0),
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      e,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: kSubTitle.copyWith(
                                        fontSize: 10,
                                          color: primaryColor),
                                    ));
                      }).toList(),
                    ),
                  )),
            ],
          ),
          _buildTitlePositionWidget('BỘ THỦ')
        ],
      ),
    );
  }

  Future<List<Vocabulary>> fetchData(String text) async {
    final listIntVoc = SplitText().extractVocabularies(text);
    final listVocs = await KanjiRepository.instance.getVocabularies(listIntVoc);
    return listVocs;
  }

  _buildVocabularies(Kanji kanji) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
            .copyWith(bottom: 15),
        decoration: BoxDecoration(
          color: kanjiColor1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<List<Vocabulary>>(
            future: fetchData(kanji.vocabularies),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Stack(
                  children: [
                    const SizedBox(
                        child: SpinKitCircle(
                      color: secondaryColor,
                      size: 50.0,
                      duration: Duration(seconds: 1),
                    )),
                    _buildTitlePositionWidget('TỪ VỰNG')
                  ],
                );
              } else if (snapshot.hasData) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return _buildVocItem(snapshot.data![index]);
                            },
                          ),
                        ),
                      ],
                    ),
                    _buildTitlePositionWidget('TỪ VỰNG')
                  ],
                );
              } else {
                return const Text('eerrr');
              }
            }));
  }

  _buildVocabulary(KanjiLoaded state) {
    if (state.listVocs.isEmpty) {
      context
          .read<KanjiBloc>()
          .add(UpdateListVocabularies(kanji: state.kanjiCurrent , context: context));
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
            .copyWith(bottom: 15),
        decoration: BoxDecoration(
          color: kanjiColor1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            const SizedBox(
                child: SpinKitCircle(
              color: secondaryColor,
              size: 50.0,
              duration: Duration(seconds: 1),
            )),
            _buildTitlePositionWidget('TỪ VỰNG')
          ],
        ),
      );
    } else {

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
            .copyWith(bottom: 15),
        decoration: BoxDecoration(
          color: kanjiColor1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.listVocs.length,
                    itemBuilder: (context, index) {
                      return _buildVocItem(state.listVocs[index]);
                    },
                  ),
                ),
              ],
            ),
            _buildTitlePositionWidget('TỪ VỰNG')
          ],
        ),
      );
    }
  }

  _buildTitlePositionWidget(String text) {
    return Positioned(
        top: 0,
        left: 0,
        width: 90,
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kanjiColor1,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            border: Border.all(color: secondaryColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kTitle.copyWith(fontSize: 12),
          ),
        ));
  }

  _buildTitleUsageWidget() {
    return Positioned(
        top: 0,
        left: 0,
        width: 130,
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kanjiColor1,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            border: Border.all(color: secondaryColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Text(
            'Cách sử dụng'.toUpperCase(),
            textAlign: TextAlign.center,
            style: kTitle.copyWith(fontSize: 12),
          ),
        ));
  }

  _buildVocItem(Vocabulary vocabulary) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final path = await AudioHelper.instance.getPathFileVocabulary(vocabulary.id);
                if(path == '') return;
                await audioplayer.setFilePath(path);
                await audioplayer.play();
              },
              child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                    border: Border.all(color: secondaryColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0.0, 3.0),
                        spreadRadius: 2,
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.volume_down_rounded,
                    size: 25,
                    color: secondaryColor,
                  )),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 5, child: _buildFuriganaColumnText(vocabulary.furigana)),
          Expanded(
              flex: 5,
              child: Text(
                vocabulary.vi,
                style: kTitle,
                maxLines: 2,
              )),
        ],
      ),
    );
  }

  _buildFuriganaColumnText(String furigana) {
    var list = SplitText().splitFuriganaVoc(furigana);
    return Row(
      children: list.map((e) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              e.split('|')[1],
              style: kSubTitle,
            ),
            Text(
              e.split('|')[0],
              style: kTitle,
            ),
          ],
        );
      }).toList(),
    );
  }

  _buildFloatAction(KanjiLoaded state, BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    final index = state.listKanjis
        .indexWhere((element) => element.id == state.kanjiCurrent.id);
    final max = state.listKanjis.length;
    return Positioned(
        bottom: 60,
        left: (widthDevice - 180) / 2,
        child: Container(
          height: 35,
          width: 180,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: secondaryColor.withOpacity(0.5),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    final previousIndex =
                        index - 1 < 0 ? max - 1 : index - 1;
                    _animationController.forward(from: 0);
                    context.read<KanjiBloc>().add(UpdateKanjiCurrent(
                        kanji: state.listKanjis[previousIndex]));
                  },
                  child: Container(
                    width: 50,
                    child: const Icon(
                      Icons.arrow_left_sharp,
                      color: primaryColor,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 9),
                    color: primaryColor,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      '${index+1}/$max',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kTitle.copyWith(
                          color: primaryColor, fontSize: 10),
                    ),
                  ),
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 9),
                    color: primaryColor,
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    final nextIndex = index + 1 >= max ? 0 : index + 1;
                    _animationController.forward(from: 0);
                    context.read<KanjiBloc>().add(UpdateKanjiCurrent(
                        kanji: state.listKanjis[nextIndex]));
                  },
                  child: Container(
                    width: 50,
                    child: const Icon(
                      Icons.arrow_right_sharp,
                      color: primaryColor,
                    ),
                  )),
            ],
          ),
        ));
  }
}
