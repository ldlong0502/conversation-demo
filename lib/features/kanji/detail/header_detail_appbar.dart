import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_cubit/kanji_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:untitled/models/kanji.dart';
import 'package:drawing_animation/drawing_animation.dart';
import '../../../utils/split_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HeaderDetailAppbar extends StatefulWidget {
   HeaderDetailAppbar({Key? key, required this.kanji, required this.onHighLight, required this.animationController}) : super(key: key);
  final Kanji kanji;
  final Function() onHighLight;
   AnimationController animationController;
  @override
  State<HeaderDetailAppbar> createState() => _HeaderDetailAppbarState();
}

class _HeaderDetailAppbarState extends State<HeaderDetailAppbar>  with SingleTickerProviderStateMixin{
  @override
  void initState() {
    super.initState();

    widget.animationController.forward(from: 0.0);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<KanjiCubit>();
    final listStringPath = SplitText().extractPathDataList(widget.kanji.path);
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
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: AppColor.blue,
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
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          cubit.closeCubit();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColor.white,
                        )),
                  ),
                ),
                 Expanded(
                    flex: 3,
                    child: Center(
                        child: Text(
                          AppTextTranslate.getTranslatedText(EnumAppText.txtDetail),
                          style: const TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ))),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onHighLight();
                    },
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          !cubit.state!.isHighLight
                              ? 'assets/images/ic_idea_border.png'
                              : 'assets/images/ic_idea_fill.png',
                          height: 40,
                          color: AppColor.white,
                        )),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if(!mounted) return;
              if (!widget.animationController.isAnimating) {
                widget.animationController.forward(from: 0.0);
              }
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: AppColor.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: AnimatedDrawing.paths(
                      listPath,
                      paints: listPaints,
                      controller: widget.animationController,
                      run: widget.animationController.isAnimating,
                      duration: widget.animationController.duration,
                      onFinish: () {
                        widget.animationController.stop();
                      },
                    ),
                  ),
                  Text(
                    widget.kanji.mean,
                    style: AppStyle.kTitle.copyWith(color: Colors.black, fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
