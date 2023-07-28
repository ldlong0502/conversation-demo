import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/blocs/bloc_kanji/kanji_bloc.dart';

import '../../constants/constants.dart';
import '../../models/kanji.dart';
import '../../utils/split_text.dart';
import 'package:path_drawing/path_drawing.dart';

import '../widgets/draw_room_widget.dart';
class PracticeWriteScreen extends StatelessWidget {
  const PracticeWriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KanjiBloc, KanjiState>(
        builder: (context, state) {
          if(state is KanjiLoaded){
            final size = MediaQuery.of(context).size;
            return Scaffold(
              backgroundColor: primaryColor,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: headerTitle(context, state.kanjiCurrent, state),
              ),
              body: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20).copyWith(bottom: 50),
                    height: size.height * 0.8,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                        color: kanjiColor1.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20)),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100,),
                        Expanded(
                          flex: 3,
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 200,
                                      padding:const EdgeInsets.only(bottom: 5),
                                      child: Stack(
                                        children: [
                                          Opacity(
                                            opacity: !state.isHideActionPracticeWriting ? 1 : 0,
                                            child: CustomPaint(
                                              painter: CustomPathPainter(stringPath: state.kanjiCurrent.path),
                                            ),
                                          ),
                                          Align(
                                              child: Container(
                                            height: 0.5,
                                            color: Colors.black54,
                                            width: 140,
                                          )),
                                          Align(
                                              child: Container(
                                                height: 140,
                                                color: Colors.black54,
                                                width: 0.5,
                                              ))
                                        ],
                                      ),
                                    ),

                                  ],
                                ),

                              ],
                            )),
                          Expanded(child: Text( state.kanjiCurrent.vi,
                          style: kTitle.copyWith(
                            fontSize: 25
                          ),
                          ))
                      ],
                    ),
                  ),
                  DrawingRoomWidget(state: state)
                ],
              ),
            );

          }
          else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),);
          }
        }
    );
  }
  headerTitle(BuildContext context, Kanji kanji, KanjiLoaded state) {


    return Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
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
                          color: secondaryColor,
                        )),
                  ),
                ),
                const Expanded(
                    flex: 3,
                    child: Center(
                        child: Text(
                          'Luyện viết',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ))),
                Expanded(
                  child: Container()
                )
              ],
            ),
          ),
        ]));
  }
}

class CustomPathPainter extends CustomPainter {
  final String stringPath;
  const CustomPathPainter({Key? key , required this.stringPath});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kanjiColor1
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