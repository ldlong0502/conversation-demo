import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/bloc_kanji/kanji_bloc.dart';
import '../../constants/constants.dart';
import '../../models/kanji.dart';
import '../../utils/split_text.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({Key? key , required this.listKanjis}) : super(key: key);
  final List<Kanji> listKanjis;



  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>  with TickerProviderStateMixin{
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final Random random = Random();
  int index = 0;
  late List<Map<String, dynamic>> listMaps;
  List<GlobalKey<PageFlipBuilderState>> listPageFlipKey = [];

  @override
  void initState() {
    var listItems = List.of(widget.listKanjis);
    listItems.shuffle();

    listMaps = listItems.map((item) {
      return {
        'item': item,
        'isFront': true,
      };
    }).toList();
    for(var i in listMaps) {
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
          backgroundColor: kanjiColor2,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: headerTitle(),
          ),
          body: Container(
            child: Column(

              children: [
                Container(
                  height: size.height * 0.75,
                  child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _pageController,
                      itemCount: listMaps.length,
                      itemBuilder: (context, idx) {
                        return _buildCardItem(listMaps[idx] , idx);
                      }),
                ),
              ],
            ),
          ),
        ),
        _buildFloatAction(),
      ],
    );
  }

  headerTitle() {

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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                          'Flashcard',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ))),
                Expanded(
                 child: Container(),
                )
              ],
            ),
          ),
        ]));
  }

  Widget _buildCardItem(Map<String, dynamic> item , int idx) {

    return GestureDetector(
      onTap:(){

        listPageFlipKey[idx].currentState?.flip();
      },
        child: PageFlipBuilder(
          key: listPageFlipKey[idx],
          interactiveFlipEnabled: false,
          maxTilt: 0.003,
          // customize scale
          maxScale: 0.1,
          nonInteractiveAnimationDuration: Duration(seconds: 1),
          frontBuilder: (_) => _buildFront(item),
          backBuilder: (_) => _buildBack(item),
        )
    );
  }

  _buildFront(Map<String, dynamic> item) {
    return  Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5 , vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CustomPaint(
                size: Size(200,200),
                painter: CustomPathPainter(stringPath: item['item'].path),
              ),),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            left: 5,
            width: 130,
            height: 40,
            child: Container(
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)
              )
            ),
              child: Center(
                child: Text('LẬT VỀ SAU',
                  style: kTitle.copyWith(
                  color: primaryColor,
                    fontSize: 12
                ),),
              ),
        ))
      ],
    );
  }

  _buildBack(Map<String, dynamic> item) {
    return  Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 20,),
                      Text(item['item'].kanji , style: kTitle.copyWith(
                        fontSize: 60
                      ),),
                      Text(item['item'].vi , style: kTitle.copyWith(
                        fontSize: 20
                      ),),
                    ],
                  )

              ),
              Expanded(
                flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(

                      children: [
                        Expanded(
                          child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                            children: SplitText().extractRhythmKanji(item['item'].kunyomi).map((e) => Text(e , style: kTitle.copyWith(
                              fontSize: 20
                            ),)).toList(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: SplitText().extractRhythmKanji(item['item'].onyomi).map((e) => Text(e ,style: kTitle.copyWith(
                                fontSize: 20
                            ),)).toList(),
                          ),
                        )
                      ],
                    ),
                  )

              ),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            right: 5,
            width: 130,
            height: 40,
            child: Container(
              decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)
                  )
              ),
              child: Center(
                child: Text('LẬT VỀ TRƯỚC',
                  style: kTitle.copyWith(
                      color: primaryColor,
                    fontSize: 12
                  ),),
              ),
            ))
      ],
    );
  }
  _buildFloatAction() {
    final widthDevice = MediaQuery.of(context).size.width;
    final max = listMaps.length;
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
                    _pageController.animateToPage(previousIndex, duration: Duration(milliseconds: 1000), curve: Curves.easeOut);

                  },
                  child: const Icon(
                    Icons.arrow_left_sharp,
                    color: primaryColor,
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
                    _pageController.animateToPage(nextIndex, duration: Duration(milliseconds: 1000), curve: Curves.easeOut);

                  },
                  child: const Icon(
                    Icons.arrow_right_sharp,
                    color: primaryColor,
                  )),
            ],
          ),
        ));
  }
}

class CustomPathPainter extends CustomPainter {
  final String stringPath;
  const CustomPathPainter({Key? key , required this.stringPath});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = secondaryColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Define the path data
    final listStringPath = SplitText().extractPathDataList(stringPath);
    int count= 1;
    canvas.scale(2,1.8);
    for (var i in listStringPath) {
      var path = parseSvgPathData(i);
      final center = path.getBounds().topLeft;

      path = path.shift(Offset(0, 0));

      canvas.drawPath(path, paint);
      TextSpan span =  TextSpan(
        style: const TextStyle(fontSize: 8, color: Colors.black),
        text: (count++).toString(),
      );

      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      final numberOffset = Offset(center.dx, center.dy);
      // tp.paint(canvas,  numberOffset);
    }
    // Create a Path object from the data
  }

  @override
  bool shouldRepaint(CustomPathPainter oldDelegate) {
    return true;
  }
}