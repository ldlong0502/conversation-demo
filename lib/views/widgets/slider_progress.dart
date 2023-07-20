import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/blocs/bloc_conversation/conversation_bloc.dart';
import '../../blocs/bloc_lesson/lesson_bloc.dart';
import '../../constants/constants.dart';
import '../../models/lesson.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/audio_helper.dart';

class SliderProgress extends StatefulWidget {
  const SliderProgress(
      {Key? key,
      required this.lesson,
      required this.state,
      required this.scrollController})
      : super(key: key);
  final Lesson lesson;
  final ConversationLoaded state;
  final ScrollController scrollController;

  @override
  State<SliderProgress> createState() => _SliderProgressState();
}

class _SliderProgressState extends State<SliderProgress> {
  void initPlayer() async {
    final pathAudio =
        await AudioHelper.instance.getPathFileAudio(widget.lesson.mp3);
    await widget.state.audioPlayer
        .setFilePath(pathAudio, initialPosition: widget.lesson.durationCurrent);
    await widget.state.audioPlayer.play();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
    widget.state.audioPlayer.positionStream.listen((position) {
      if (!mounted) return;
      var pos = position.inMilliseconds.toDouble();
      if (pos > widget.lesson.durationMax.inMilliseconds.toDouble()) {

        context
            .read<ConversationBloc>()
            .add(const UpdateTimeHighLight(timeHighLight: 0));

        context
            .read<ConversationBloc>()
            .add(const ConversationPlay(isPlaying: false));
        context.read<LessonBloc>().add(
            LessonInitAgain(lesson: widget.lesson));
        widget.state.audioPlayer.seek(const Duration(milliseconds: 0));
        widget.state.audioPlayer.pause();

      } else {
        context
            .read<ConversationBloc>()
            .add(UpdateTimeHighLight(timeHighLight: pos));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.state.audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () async {
            print(widget.state.isPlaying);
            if (widget.state.isPlaying) {
              context
                  .read<ConversationBloc>()
                  .add(const ConversationPlay(isPlaying: false));
            } else {
              context
                  .read<ConversationBloc>()
                  .add(const ConversationPlay(isPlaying: true));
            }
          },
          child: Container(
            height: 25,
            width: 25,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: secondaryColor),
            alignment: Alignment.center,
            child: Icon(widget.state.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white, size: 20),
          ),
        ),
        Flexible(
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight: 0.5,
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
            ),
            child: Slider(
              value: widget.state.timePosition,
              min: 0,
              max: widget.lesson.durationMax.inMilliseconds.toDouble(),
              thumbColor: secondaryColor,
              activeColor: secondaryColor,
              onChanged: (value) {
                context
                    .read<ConversationBloc>()
                    .add(UpdateTimeHighLight(timeHighLight: value));
                widget.state.audioPlayer
                    .seek(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
        ),
      ],
    );
  }
}
