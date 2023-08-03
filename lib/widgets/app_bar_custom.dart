import 'package:flutter/material.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
class AppBarCustom extends StatelessWidget {
  const AppBarCustom({Key? key, required this.title, required this.bgColor, required this.textColor}) : super(key: key);
  final String title;
  final Color bgColor;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:  Icon(
                          Icons.arrow_back_ios_new,
                          color: textColor,
                        )),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Center(
                        child: AutoSizeText(
                          title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: AppStyle.kTitle.copyWith(
                            color: textColor,
                          ),
                        ))),
                Expanded(child: Container())
              ],
            ),
          ])),
    );
  }
}
