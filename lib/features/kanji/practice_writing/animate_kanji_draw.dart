import 'package:flutter/material.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:untitled/blocs/kanji_practice_writing_cubit/kanji_practice_writing_cubit.dart';
import '../../../configs/app_color.dart';
import '../../../utils/split_text.dart';

class AnimateKanjiDraw extends StatelessWidget {
  const AnimateKanjiDraw({Key? key, required this.animationController, required this.state})
      : super(key: key);
  final AnimationController animationController;
  final KanjiPracticeWritingLoaded state;
  @override
  Widget build(BuildContext context) {
    final listStringPath =
        SplitText().extractPathDataList(state.kanji.path);
    final paint = Paint()
      ..color = AppColor.blue
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    var listPath = <Path>[];
    var listPaints = <Paint>[];
    for (var i in listStringPath) {
      listPath.add(parseSvgPathData(i));
      listPaints.add(paint);
    }
    return Positioned(
        top: 50,
        left: 30,
        child: Opacity(
          opacity: !state.isHideCoordinates ? 1 : 0,
          child: Container(
            margin: const EdgeInsets.all(20),
            height: 70,
            width: 70,
            child: Stack(
              children: [
                AnimatedDrawing.paths(
                  listPath,
                  paints: listPaints,
                  controller: animationController,
                  run: animationController.isAnimating,
                  duration: animationController.duration,
                  onFinish: () {
                    animationController.stop();
                  },
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
        ));
  }
}
