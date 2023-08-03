import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:untitled/models/kanji.dart';

import 'custom_painter.dart';
class FrontItem extends StatelessWidget {
  const FrontItem({Key? key, required this.item}) : super(key: key);
  final Kanji item;
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5 , vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CustomPaint(
                size: const Size(200,200),
                painter: CustomKanjiPaint(stringPath: item.path),
              ),),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            left: 5,
            width: 130,
            height: 40,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColor.blue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)
                  )
              ),
              child: Center(
                child: Text(
                  AppTextTranslate.getTranslatedText(EnumAppText.txtFlipBehind),
                  style: AppStyle.kTitle.copyWith(
                      color: AppColor.white,
                      fontSize: 12
                  ),),
              ),
            ))
      ],
    );
  }
}
