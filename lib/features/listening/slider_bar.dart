import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import '../../configs/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/position_data.dart';
import '../../repositories/lesson_repository.dart';
import '../../services/sound_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';

class SliderBar extends StatefulWidget {
  const SliderBar({Key? key, required this.positionNow}) : super(key: key);
  final Duration positionNow;
  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  final soundService = SoundService.instance;

  Stream<PositionData> get positionDataSteam =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          soundService.player!.positionStream,
          soundService.player!.bufferedPositionStream,
          soundService.player!.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              duration: duration ?? Duration.zero,
              bufferedPosition: bufferedPosition));

  onInit() async {
    final lesson = context.read<CurrentLessonCubit>();
    lesson.setIsDetailPage(true);
    final pathAudio =
        LessonRepository.instance.getUrlAudioById(lesson.state!.id.toString());
    await soundService.playSoundNotCreateNew(pathAudio , widget.positionNow);
    soundService.player!.positionStream.listen((position) {
      if(soundService.player!.duration == null) return;
      if(!lesson.isDetailPage) return;
      if (position.inMilliseconds >=
          soundService.player!.duration!.inMilliseconds) {
        soundService.stop();
        soundService.seek(const Duration(seconds: 0));
        lesson.scrollControllerConversation.scrollTo(
            index: 0,
            alignment: 0.2,
            duration: const Duration(milliseconds: 500));
      }
      lesson.conversationScrollToIndex();
      lesson.highLightConversation();
    });
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }
 @override
  void deactivate() {
   final cubit = context.read<CurrentLessonCubit>();
   cubit.setIsDetailPage(false);
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: StreamBuilder<PlayerState>(
              stream: soundService.player!.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                debugPrint(playerState?.processingState.toString());
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (!(playing ?? false)) {
                  return GestureDetector(
                      onTap: soundService.player!.play,
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
                      onTap: soundService.player!.pause,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.blue,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.pause,
                          size: 25,
                          color: AppColor.white,
                        ),
                      ));
                }
                return Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.blue,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.play_arrow,
                      color: Colors.white, size: 25),
                );
              }),
        ),
        Flexible(
          child: SliderTheme(
              data: const SliderThemeData(
                trackHeight: 0.5,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
              ),
              child: StreamBuilder<PlayerState>(
                  stream: soundService.player!.playerStateStream,
                  builder: (context, snapshot) {
                    return StreamBuilder<PositionData>(
                        stream: positionDataSteam,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          if (positionData == null) return Container();
                          return Slider(
                            value:
                                positionData.position.inMilliseconds.toDouble(),
                            max: positionData.duration.inMilliseconds
                                .toDouble(),
                            min: 0,
                            thumbColor: AppColor.blue,
                            activeColor: AppColor.blue,
                            onChanged: (value) {
                              soundService
                                  .seek(Duration(milliseconds: value.toInt()));
                            },
                          );
                        });
                  })),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }
}
