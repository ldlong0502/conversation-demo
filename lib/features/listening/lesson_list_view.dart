import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/features/listening/lesson_item.dart';

import '../../models/lesson.dart';

class LessonListView extends StatelessWidget {
  const LessonListView({Key? key, required this.listLessons}) : super(key: key);
  final List<Lesson> listLessons;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: listLessons.length,
          itemBuilder: (context, idx) {
            return Container(
              height: 55,
              margin: const EdgeInsets.symmetric(vertical: 3 , horizontal: 10),
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0.0, 0.3),
                      spreadRadius: 4,
                      blurRadius: 4.0,
                    ),
                  ],
                  border: Border.all(color: AppColor.blue, width: 1),
                  ),

              child: LessonItem(lesson: listLessons[idx],)
            );
          }),
    );
  }
}
