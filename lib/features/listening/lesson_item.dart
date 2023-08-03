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

class LessonItem extends StatelessWidget {
  const LessonItem({Key? key, required this.lesson}) : super(key: key);
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: ()  {
           context.read<CurrentLessonCubit>().pause();
          context.read<ConversationListCubit>().getData(lesson);
          var currentLesson = context.read<CurrentLessonCubit>().state!;
          if(currentLesson.id == lesson.id) {
            context.read<ConversationPlayerCubit>().load(context , currentLesson);
          }
          else{
            context.read<ConversationPlayerCubit>().load(context ,lesson);
          }


          Navigator.pushNamed(context, AppRoutes.practiceListeningDetail);
          // print('long' + lesson.durationMax.inMilliseconds.toString());
          // context.read<LessonBloc>().add(LessonStopped());
          // _goToConversation(lesson);
        },
        child: SizedBox(
          child: Row(
            children: [
              Expanded(child: BlocBuilder<CurrentLessonCubit, Lesson?>(
                builder: (context, state) {
                  return GestureDetector(
                      onTap: () async {
                        if (state!.id == lesson.id) {
                          if (state!.isPlaying) {
                            BlocProvider.of<CurrentLessonCubit>(context)
                                .pause();
                          } else {
                            BlocProvider.of<CurrentLessonCubit>(context).play();
                          }
                        }
                        else {
                          BlocProvider.of<CurrentLessonCubit>(context).playOtherItem(lesson.copyWith(
                            durationCurrent: Duration.zero
                          ));
                        }
                      },

                      // child:
                      //
                      child: _buildPlayer(state!, lesson));
                },
              )),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.vi, style: AppStyle.kTitle, maxLines: 1),
                    Text(lesson.title, style: AppStyle.kSubTitle, maxLines: 1),
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

  _buildPlayer(Lesson lessonNow, Lesson item) {
    if (item.id == lessonNow.id) {
      return lessonNow.isLoading
          ? Container(
              height: 25,
              width: 25,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const CircularProgressIndicator())
          : lessonNow.isPlaying
              ? Container(
                  height: 25,
                  width: 25,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: CircularBar(
                    lesson: lessonNow,
                  ),
                )
              : Container(
                  height: 35,
                  width: 35,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
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
                );
    } else {
      return Container(
        height: 35,
        width: 35,
        margin: const EdgeInsets.symmetric(horizontal: 10),
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
      );
    }
  }
}
