import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LessonGridItemWidget extends StatelessWidget {
  const LessonGridItemWidget({Key? key, required this.title, required this.iconUrl, required this.onPress}) : super(key: key);
  final String title;
  final String iconUrl;
  final Function() onPress;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizeContainer = (size.width - 75 ) / 3;
    return GestureDetector(
      onTap: onPress,
      child: Stack(
        children: [
          Container(
            height: sizeContainer * 3,
            width: sizeContainer * 3,
            margin: const  EdgeInsets.only(top: 15),
            decoration:  BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: secondaryColor,
                width: 1
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(3.0,8.0),
                  spreadRadius: 5,
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(
                  height: sizeContainer - 20
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(title, style: kTitle.copyWith(
                    color: Colors.black,

                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child:  LinearPercentIndicator(
                    animation: true,
                    lineHeight: 5.0,
                    animationDuration: 2000,
                    percent: 0.5,
                    barRadius: const Radius.circular(20.0),
                    progressColor: secondaryColor,
                  ),
                )


              ],
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              height: sizeContainer - 20,
              width: sizeContainer - 20,
              child: Image.asset(iconUrl , fit: BoxFit.cover,)),
        ],
      ),
    );
  }
}
