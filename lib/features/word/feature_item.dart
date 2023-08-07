import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
class FeatureItem extends StatelessWidget {
  const FeatureItem({Key? key, required this.asset, required this.title, required this.onPress}) : super(key: key);
  final String asset;
  final String title;
  final Function() onPress;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(asset, height: 60,),
        Text(title , style: AppStyle.kTitle.copyWith(
          color: AppColor.white
        ),)
      ],
    );
  }
}
