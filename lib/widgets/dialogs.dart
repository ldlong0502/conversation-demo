
import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'custom_alert.dart';
class Dialogs {
  showSorryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15.0),
              Text(
               AppTextTranslate.getTranslatedText(EnumAppText.txtSorry),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 25.0),
               Text(
                AppTextTranslate.getTranslatedText(EnumAppText.txtNotFoundLesson),
                style:  const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                    width: 130.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor:
                        AppColor.blue,
                      ),
                      child:  Text(
                        AppTextTranslate.getTranslatedText(EnumAppText.txtBack),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
  void showYoutubePopup(BuildContext context, String videoId) {
    double deviceWidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: deviceWidth,
              child: YoutubePlayer(
                width: 360,
                        controller: YoutubePlayerController(
                          initialVideoId: videoId,
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.blue,
                          handleColor: Colors.blueAccent,
                        ),
                      ),
            ),
          );
      },
    );
  }

}