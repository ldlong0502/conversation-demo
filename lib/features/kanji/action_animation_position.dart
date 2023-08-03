import 'package:flutter/material.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:untitled/features/kanji/grid_view_action.dart';

import '../../configs/app_color.dart';
import '../../models/kanji.dart';
class ActionAnimationPosition extends StatefulWidget {
  const ActionAnimationPosition({Key? key, required this.listKanjis}) : super(key: key);
  final List<Kanji> listKanjis;
  @override
  State<ActionAnimationPosition> createState() => _ActionAnimationPositionState();
}

class _ActionAnimationPositionState extends State<ActionAnimationPosition> {
  double offset = -130;
  bool isDragUp = false;
  @override
  Widget build(BuildContext context) {
    return  AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        bottom: offset,
        left: 20,
        right: 20,
        child: GestureDetector(
          onVerticalDragUpdate: (value) {
            double currentDragY = MediaQuery.of(context).size.height -
                value.globalPosition.dy -
                150;
            setState(() {
              if (offset < currentDragY) {
                isDragUp = true;
              } else {
                isDragUp = false;
              }
              offset = currentDragY;

              if (offset > 20) {
                offset = 20;
              } else if (offset < -130) {
                offset = -130;
              }
            });
          },
          onVerticalDragEnd: (value) {
            setState(() {
              if (isDragUp) {
                offset = 20;
              } else {
                offset = -130;
              }
            });
          },
          child: Stack(
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: const BoxDecoration(
                      color: AppColor.blue,
                      borderRadius:
                      BorderRadius.all(Radius.circular(25))),
                  height: 170,
                  child:  GridViewAction(listKanjis: widget.listKanjis,)),
              Positioned(
                  top: 0,
                  right: 0,
                  height: 25,
                  child: AnimatedOpacity(
                    opacity: (offset == 20) ? 1.0 : 0.0,
                    // Show the container when offset = 20, otherwise hide it
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          offset = -130;
                        });
                      },
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                            color: AppColor.white,
                            border: Border.all(
                                color: AppColor.blue, width: 1),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25))),
                        child: const Center(
                          child: Icon(
                            Icons.clear_rounded,
                            color: AppColor.blue,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    ignoring: (offset > -80),
                    child: AnimatedOpacity(
                      opacity: (offset > -80) ? 0.0 : 1.0,
                      // Show the container when offset = 20, otherwise hide it
                      duration: const Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isDragUp = true;
                            offset = 20;
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: const BoxDecoration(
                              color: AppColor.blue,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25))),
                          child: Center(
                              child: Text(
                                AppTextTranslate.getTranslatedText(EnumAppText.txtPractice),
                                style: AppStyle.kTitle.copyWith(
                                    fontSize: 18, color: AppColor.white),
                              )),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
