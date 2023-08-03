import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../enums/app_text.dart';
import '../../models/lesson.dart';

class AppbarPlayer extends StatelessWidget {
  const AppbarPlayer({Key? key}) : super(key: key);

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
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_previous,
                          color: AppColor.blue,
                          size: 40,
                        )),
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.blue,
                        child: IconButton(
                            onPressed: () async {
                              if (state!.isPlaying) {
                                BlocProvider.of<CurrentLessonCubit>(context)
                                    .pause();
                              } else {
                                BlocProvider.of<CurrentLessonCubit>(context)
                                    .play();
                              }
                            },
                            icon: Icon(
                              state!.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: AppColor.white,
                              size: 40,
                            ))),
                    IconButton(
                        onPressed: () {},
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
