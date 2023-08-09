import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';

class WordFloatNavigateButton extends StatelessWidget {
  const WordFloatNavigateButton({Key? key, required this.index, required this.max, required this.onPrevious, required this.onNext , this.color = AppColor.orange}) : super(key: key);
  final int index;
  final int max;
  final Function() onPrevious;
  final Function() onNext;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    return Positioned(
        bottom: 20,
        left: (widthDevice - 180) / 2,
        child: Container(
          height: 35,
          width: 180,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
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
                    onPrevious();
                  },
                  child: const SizedBox(
                    width: 50,
                    child: Icon(
                      Icons.arrow_left_sharp,
                      color: AppColor.white,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 9),
                    color: AppColor.white,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      '${index+1}/$max',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.kTitle.copyWith(
                          color: AppColor.white, fontSize: 10),
                    ),
                  ),
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 9),
                    color: AppColor.white,
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    onNext();
                  },
                  child: const SizedBox(
                    width: 50,
                    child: Icon(
                      Icons.arrow_right_sharp,
                      color: AppColor.white,
                    ),
                  )),
            ],
          ),
        ));
  }
}
