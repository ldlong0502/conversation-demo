import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_player_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/features/listening/lesson_item.dart';
import 'package:untitled/repositories/conversation_repository.dart';

import '../../blocs/practice_listening_cubit/conversation_list_cubit.dart';
import '../../blocs/practice_listening_cubit/listening_list_cubit.dart';
import '../../models/conversation.dart';
import '../../models/lesson.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_progress.dart';

class LessonListView extends StatefulWidget {
  const LessonListView({Key? key, required this.listLessons}) : super(key: key);
  final List<Lesson> listLessons;

  @override
  State<LessonListView> createState() => _LessonListViewState();
}

class _LessonListViewState extends State<LessonListView> {
  @override
  void deactivate() {
    context.read<CurrentLessonCubit>().dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentLessonCubit, Lesson?>(
      builder: (context, state) {
        if (state == null) return const LoadingProgress();
        return BlocProvider(
          create: (context) => ConversationPlayerCubit(context),
          child: BlocBuilder<ConversationPlayerCubit, Lesson?>(
            builder: (context, state) {

              return Padding(
                padding: const EdgeInsets.only(top: 150),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.listLessons.length,
                    itemBuilder: (context, idx) {
                      return Container(
                          height: 55,
                          margin: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0.0, 0.3),
                                spreadRadius: 4,
                                blurRadius: 4.0,
                              ),
                            ],
                            border: Border.all(color: AppColor.blue, width: 1),
                          ),

                          child: LessonItem(
                            lesson: widget.listLessons[idx],)
                      );
                    }),
              );
            },
          ),
        );
      },
    );
  }
}
