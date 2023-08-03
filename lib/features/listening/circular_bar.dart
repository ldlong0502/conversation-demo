import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import '../../models/lesson.dart';
class CircularBar extends StatelessWidget {
  const CircularBar({Key? key, required this.lesson}) : super(key: key);
  final Lesson lesson;
  @override
  Widget build(BuildContext context) {
    double progress =
        lesson.durationCurrent.inMilliseconds / lesson.durationMax.inMilliseconds;
    return SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 3,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColor.blue),
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}
