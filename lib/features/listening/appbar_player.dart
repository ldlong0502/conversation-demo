import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import '../../enums/app_text.dart';
import '../../models/lesson.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/position_data.dart';
import '../../services/sound_service.dart';

class AppbarPlayer extends StatefulWidget {
  const AppbarPlayer({Key? key, required this.positionDataSteam}) : super(key: key);
  final Stream<PositionData> positionDataSteam;

  @override
  State<AppbarPlayer> createState() => _AppbarPlayerState();
}

class _AppbarPlayerState extends State<AppbarPlayer> {
  final soundService = SoundService.instance;
  onInit() async {
    final cubit = context.read<CurrentLessonCubit>();
    final pathAudio = LessonRepository.instance.getUrlAudioById(cubit.state!.id.toString());
    await soundService.player!.setFilePath(pathAudio);
    soundService.player!.positionStream.listen((position) {
      if( soundService.player!.duration == null) return;
      if (position.inMilliseconds >=
          soundService.player!.duration!.inMilliseconds) {
        debugPrint('=>>>>>>>>> aaaaaa');
        if(cubit.isDetailPage) return;
        cubit.playNext();
      }
    });
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
                          stream: soundService.player!.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState = playerState?.processingState;
                            final playing = playerState?.playing;
                            if (!(playing ?? false)) {

                              return IconButton(
                                  onPressed: soundService.player!.play,
                                  iconSize: 40,
                                  color: AppColor.white,
                                  icon: const Icon(Icons.play_arrow_rounded));
                            } else if (processingState != ProcessingState.completed) {
                              print(processingState);
                              return IconButton(
                                  onPressed: soundService.player!.pause,
                                  iconSize: 40,
                                  color:  AppColor.white,
                                  icon: const Icon(Icons.pause_rounded));

                            }
                            return IconButton(
                                onPressed: ()  async {
                                  final pathAudio = LessonRepository.instance.getUrlAudioById(state!.id.toString());
                                  await soundService.playSound(pathAudio);
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
