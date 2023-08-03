import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/enums/app_text.dart';

class CornerTitle extends StatelessWidget {
  const CornerTitle({Key? key , this.width = 50, required this.title}) : super(key: key);
  final double width;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        width: width,
        child: Container(
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.whiteAccent1,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            border: Border.all(color: AppColor.blue),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyle.kTitle.copyWith(fontSize: 12),
          ),
        ));
  }
}
