import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../services/sound_service.dart';
class AppBarCustomSound extends StatefulWidget {
  const AppBarCustomSound({Key? key, required this.title, required this.bgColor, required this.textColor}) : super(key: key);
  final String title;
  final Color bgColor;
  final Color textColor;

  @override
  State<AppBarCustomSound> createState() => _AppBarCustomSoundState();
}

class _AppBarCustomSoundState extends State<AppBarCustomSound> {

  bool isMute = false;

  @override
  void dispose() {
    SoundService.instance.unMute();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: widget.bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Row(
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
                        color: widget.textColor,
                      )),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Center(
                      child: AutoSizeText(
                        widget.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: AppStyle.kTitle.copyWith(
                          color: widget.textColor,
                        ),
                      ))),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        if(isMute) {
                          SoundService.instance.unMute();
                        }
                        else {
                          SoundService.instance.mute();
                        }
                        setState(() {
                          isMute= !isMute;
                        });
                      },
                      child: Icon(isMute ? Icons.volume_mute_rounded :Icons.volume_down_sharp , color: AppColor.white,)),
              )
            ],
          )),
    );
  }
}
