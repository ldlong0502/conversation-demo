import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_list_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_player_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/features/listening/circular_bar.dart';
import 'package:untitled/routes/app_routes.dart';

import '../../configs/app_color.dart';
import '../../models/lesson.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/position_data.dart';
import '../../repositories/audio_helper.dart';
import '../../widgets/ring_loading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:async/async.dart';

class LessonItem extends StatefulWidget {
  const LessonItem(
      {Key? key,
      required this.lesson,
      required this.audioPlayer})
      : super(key: key);
  final Lesson lesson;
   final AudioPlayer audioPlayer;
  @override
  State<LessonItem> createState() => _LessonItemState();
}

class _LessonItemState extends State<LessonItem> {
  Stream<PositionData> get positionDataSteam =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          widget.audioPlayer.positionStream,
          widget.audioPlayer.bufferedPositionStream,
          widget.audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              duration: duration ?? Duration.zero,
              bufferedPosition: bufferedPosition));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () async {
          var currentLesson = context.read<CurrentLessonCubit>().state!;
          if (currentLesson.id == widget.lesson.id) {
            context.read<ConversationPlayerCubit>().load(currentLesson.copyWith(
                  durationCurrent: widget.audioPlayer.position,
                  durationMax: widget.audioPlayer.duration,
                ));
          } else {
            context.read<ConversationPlayerCubit>().load(widget.lesson);
          }
          await widget.audioPlayer.stop();
          await widget.audioPlayer.seek(Duration.zero);
          Navigator.pushNamed(
              context, AppRoutes.practiceListeningDetail, arguments: {
            'conversationPlayerCubit': context.read<ConversationPlayerCubit>()
          });
        },
        child: SizedBox(
          child: Row(
            children: [
              Expanded(child: BlocBuilder<CurrentLessonCubit, Lesson?>(
                builder: (context, state) {
                  return circlePlayer(state!, widget.lesson);
                },
              )),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.lesson.vi, style: AppStyle.kTitle, maxLines: 1),
                    Text(widget.lesson.title,
                        style: AppStyle.kSubTitle, maxLines: 1),
                  ],
                ),
              ),
              const Expanded(
                  child: Icon(
                Icons.navigate_next_outlined,
                size: 25,
                color: AppColor.blue,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget circlePlayer(Lesson lessonNow, Lesson lesson2) {

    if (lessonNow.id == lesson2.id) {
      return lessonNow.isLoading ? const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [RingLoading()],
        ): StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            debugPrint(playerState?.processingState.toString());
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
             if (!(playing ?? false)) {
              return GestureDetector(
                  onTap: widget.audioPlayer.play,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.blue,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 25,
                      color: AppColor.white,
                    ),
                  ));
            } else if (processingState != ProcessingState.completed) {
              return GestureDetector(
                onTap: widget.audioPlayer.pause,
                child: StreamBuilder<PositionData>(
                    stream: positionDataSteam,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      if (positionData == null) return Container();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: positionData!.position.inMilliseconds /
                                  positionData!.duration.inMilliseconds,
                              strokeWidth: 5,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColor.blue),
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }
            return Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.blue,
              ),
              alignment: Alignment.center,
              child:
                  const Icon(Icons.play_arrow, color: Colors.white, size: 25),
            );
          });
    }
    return GestureDetector(
      onTap: () async {
        try {
          BlocProvider.of<CurrentLessonCubit>(context).load(lesson2.copyWith(
            isLoading: true
          ));
          widget.audioPlayer.stop();
          final pathFile =
              await AudioHelper.instance.getPathFileAudio(lesson2!.mp3);
          await widget.audioPlayer.setFilePath(pathFile);
          BlocProvider.of<CurrentLessonCubit>(context).load(lesson2.copyWith(
          isLoading: false,

          ));
          widget.audioPlayer.play();

        } catch (e) {
          debugPrint(e.toString());
        }
      },
      child: Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.blue,
        ),
        alignment: Alignment.center,
        child: const Icon(
            // lesson.isPlaying ? Icons.pause : Icons.play_arrow,
            Icons.play_arrow,
            color: Colors.white,
            size: 25),
      ),
    );
  }

  Future<void> getFilePath(Lesson lesson) async {
    final pathFile = await AudioHelper.instance.getPathFileAudio(lesson!.mp3);
    await widget.audioPlayer.setFilePath(pathFile);
    widget.audioPlayer.play();
  }
}
