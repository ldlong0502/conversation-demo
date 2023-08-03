import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:untitled/features/lesson_home/grid_view_action.dart';
import 'package:untitled/widgets/app_bar_custom.dart';


class LessonHomePage extends StatelessWidget {
  const LessonHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarCustom(
          title: AppTextTranslate.getTranslatedText(EnumAppText.txtLessonOne),
          bgColor: AppColor.blue,
          textColor: AppColor.white,
        ),
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            GridViewAction(),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }


}
