import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:untitled/models/grammar.dart';
import '../../widgets/dialogs.dart';

class FloatLectureButton extends StatelessWidget {
  const FloatLectureButton({Key? key, required this.grammar}) : super(key: key);
  final Grammar grammar;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 50,
        right: 0,
        child: GestureDetector(
          onTap: () {
            // if (grammar.youtubeLink == '') {
            //   Dialogs().showSorryDialog(context);
            // } else {
            //   String? videoId =
            //       YoutubePlayer.convertUrlToId(grammar.youtubeLink);
            //   Dialogs().showYoutubePopup(context, videoId!);
            // }
            Dialogs().showSorryDialog(context);
          },
          child: Container(
            height: 45,
            width: 150,
            decoration:  BoxDecoration(
              color: AppColor.blue,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0.0, 3.0),
                    spreadRadius: 2,
                    blurRadius: 4.0,
                  ),
                ]
            ),
            child: Center(
              child: Text(
                AppTextTranslate.getTranslatedText(EnumAppText.txtFloatLecture),
                style: AppStyle.kTitle.copyWith(color: AppColor.white),
              ),
            ),
          ),
        ));
  }
}
