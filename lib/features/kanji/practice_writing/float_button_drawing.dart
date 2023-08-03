import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_practice_writing_cubit/kanji_practice_writing_cubit.dart';

import '../../../configs/app_color.dart';

class FloatButtonDrawing extends StatefulWidget {
  const FloatButtonDrawing({Key? key, required this.onPlay, required this.onRedo, required this.onHide, required this.onDelete, required this.state}) : super(key: key);
  final Function() onPlay;
  final Function() onRedo;
  final Function() onHide;
  final Function() onDelete;
  final KanjiPracticeWritingLoaded state;
  @override
  State<FloatButtonDrawing> createState() => _FloatButtonDrawingState();
}

class _FloatButtonDrawingState extends State<FloatButtonDrawing> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 0,
        child: Container(
          margin: const EdgeInsets.all(30).copyWith(top: 70),
          height: 180,
          width: 45,
          decoration: BoxDecoration(
              color: AppColor.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: const Offset(1.0, 4.0),
                  spreadRadius: 2,
                  blurRadius: 4.0,
                ),
              ],
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // if (!_animationController.isAnimating) {
                  //   _animationController.forward(from: 0.0);
                  // }
                  widget.onPlay();
                },
                child: Container(
                  height: 45,
                  width: 50,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColor.white))),
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppColor.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // if (drawingPoints.isNotEmpty &&
                  //     historyDrawingPoints.isNotEmpty) {
                  //   setState(() {
                  //     drawingPoints.removeLast();
                  //   });
                  // }
                  widget.onRedo();
                },
                child: Container(
                  height: 45,
                  width: 50,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColor.white))),
                  child: const Icon(
                    Icons.restore,
                    color: AppColor.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onHide();
                  // if (widget.state.isHideCoordinates) {
                  //   _animationController.forward(from: 0.0);
                  // }
                  //
                  // BlocProvider.of<KanjiPracticeWritingCubit>(context).updateIsHideCoordinates();
                },
                child: Container(
                  height: 45,
                  width: 50,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColor.white))),
                  child: Icon(
                    !widget.state.isHideCoordinates
                        ? Icons.visibility_off:
                    Icons.visibility,
                    color: AppColor.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // setState(() {
                  //   drawingPoints.clear();
                  // });
                  widget.onDelete();
                },
                child: const SizedBox(
                  height: 45,
                  width: 50,
                  child: Icon(
                    Icons.restore_from_trash,
                    color: AppColor.white,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
