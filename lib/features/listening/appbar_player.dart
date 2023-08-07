import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../enums/app_text.dart';
import '../../models/lesson.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/position_data.dart';
import '../../repositories/audio_helper.dart';
class AppbarPlayer extends StatefulWidget {
  const AppbarPlayer({Key? key, required this.audioPlayer, required this.positionDataSteam}) : super(key: key);
  final AudioPlayer audioPlayer;
  final Stream<PositionData> positionDataSteam;

  @override
  State<AppbarPlayer> createState() => _AppbarPlayerState();
}

class _AppbarPlayerState extends State<AppbarPlayer> {
  onInit() async {
    final lesson = context.read<CurrentLessonCubit>().state!;
    final pathAudio = await AudioHelper.instance.getPathFileAudio(lesson!.mp3);
    debugPrint(pathAudio);
    await widget.audioPlayer.setFilePath(pathAudio,
        initialPosition: lesson!.durationCurrent);
  }
  @override
  void initState() {
    onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CurrentLessonCubit, Lesson?>(
        builder: (context, state) {
          return Container(
            height: 130,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0.0, 2.0),
                  blurRadius: 4.0,
                ),
              ],
              color: AppColor.white,
            ),
            child: Column(
              children: [
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
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColor.blue,
                            )),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          AppTextTranslate.getTranslatedText(
                              EnumAppText.txtPrimary1),
                          style: const TextStyle(
                              color: AppColor.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ))),
                    Expanded(child: Container())
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.compare_arrows,
                          color: AppColor.blue,
                          size: 35,
                        )),
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<CurrentLessonCubit>(context)
                              .playPrevious();
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: AppColor.blue,
                          size: 40,
                        )),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColor.blue,
                      child: StreamBuilder<PlayerState>(
                          stream: widget.audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState = playerState?.processingState;
                            final playing = playerState?.playing;
                            if (!(playing ?? false)) {

                              return IconButton(
                                  onPressed: widget.audioPlayer.play,
                                  iconSize: 40,
                                  color: AppColor.white,
                                  icon: const Icon(Icons.play_arrow_rounded));
                            } else if (processingState != ProcessingState.completed) {
                              print(processingState);
                              return IconButton(
                                  onPressed: widget.audioPlayer.pause,
                                  iconSize: 40,
                                  color:  AppColor.white,
                                  icon: const Icon(Icons.pause_rounded));

                            }
                            return IconButton(
                                onPressed: ()  async {
                                  final pathAudio = await AudioHelper.instance.getPathFileAudio(state!.mp3);
                                  debugPrint(pathAudio);
                                  await widget.audioPlayer.setFilePath(pathAudio,
                                      initialPosition: state!.durationCurrent);
                                  await widget.audioPlayer.play();
                                },
                                iconSize: 40,
                                color: AppColor.white,
                                icon: const Icon(Icons.play_arrow_rounded));
                          }),
                    ),
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<CurrentLessonCubit>(context)
                              .playNext();
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          color: AppColor.blue,
                          size: 40,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.replay_rounded,
                          color: AppColor.blue,
                        )),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
