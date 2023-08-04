import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/listening_list_cubit.dart';
import 'package:untitled/features/listening/appbar_player.dart';
import 'package:untitled/features/listening/lesson_list_view.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/widgets/loading_progress.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/practice_listening_cubit/conversation_player_cubit.dart';

class PracticeListeningPage extends StatelessWidget {
  const PracticeListeningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.99),
      body: BlocProvider(
        create: (context) => ListeningListCubit()..getData(),
        child: BlocBuilder<ListeningListCubit, List<Lesson>?>(
            builder: (context, listLessons) => listLessons == null
                ? const LoadingProgress()
                : BlocProvider(
                    create: (context) =>
                        CurrentLessonCubit(context)..load(listLessons![0]),
                    child: BlocBuilder<CurrentLessonCubit, Lesson?>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            LessonListView(listLessons: listLessons!),
                            const AppbarPlayer()
                          ],
                        );
                      },
                    ),
                  )),
      ),
    );
  }
}
