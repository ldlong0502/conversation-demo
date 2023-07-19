import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/constants/constants.dart';
import '../../blocs/bloc_lesson/lesson_bloc.dart';

class CircularProgressBar extends StatefulWidget {
  final Duration durationMax;
  final Duration durationCurrent;
  final AudioPlayer audioPlayer;

  const CircularProgressBar({
    super.key,
    required this.durationMax,
    required this.audioPlayer,
    required this.durationCurrent,
  });

  @override
  State<CircularProgressBar> createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar> {

  AudioPlayer get audioPlayer => widget.audioPlayer;
  @override
  void initState() {
    super.initState();

    print(audioPlayer.duration);
    audioPlayer.positionStream.listen((position) {
      if(!mounted) return;
      context.read<LessonBloc>().add(LessonUpdateProgress(duration: position));
    });

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if(!mounted) return;
        context.read<LessonBloc>().add(LessonPlayNext());
      }
    });
  }
  // @override
  // void dispose() {
  //   audioPlayer.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double progress =
        widget.durationCurrent.inMilliseconds / widget.durationMax.inMilliseconds;
    print(progress);
    return SizedBox(
      height: 35,
      width: 35,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 3,
        valueColor: const AlwaysStoppedAnimation<Color>(secondaryColor),
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}
