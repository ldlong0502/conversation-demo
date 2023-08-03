import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_challenge1_cubit/kanji_challenge1_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AppBarChallenge1 extends StatelessWidget {
  const AppBarChallenge1({Key? key, required this.title, required this.bgColor, required this.textColor, required this.state}) : super(key: key);
  final String title;
  final Color bgColor;
  final Color textColor;
  final KanjiChallenge1Loaded state;
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<KanjiChallenge1Cubit>();
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
                Expanded(
                    child: IconButton(
                      onPressed: (){
                        cubit.mute();
                      },
                      icon: Icon(
                        state.isMuted ?Icons.volume_mute : Icons.volume_down , color: AppColor.white,),
                    ))
              ],
            ),
          ])),
    );
  }
}
