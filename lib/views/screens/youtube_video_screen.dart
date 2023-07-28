import 'package:flutter/material.dart';
import 'package:untitled/models/grammar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class YoutubeVideoScreen extends StatelessWidget {
  final Grammar grammar;

  const YoutubeVideoScreen({super.key, required this.grammar});

  @override
  Widget build(BuildContext context) {
    String? videoId = YoutubePlayer.convertUrlToId(grammar.youtubeLink);
    print(videoId); // BBAyRBTfsOU
    return Scaffold(
      appBar: AppBar(
        title:  Text(grammar.titleVi),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId!,
            flags: const  YoutubePlayerFlags(
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
  }
}
