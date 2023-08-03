import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/listening_list_cubit.dart';
import 'package:untitled/features/listening/appbar_player.dart';
import 'package:untitled/features/listening/lesson_list_view.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/widgets/loading_progress.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PracticeListeningPage extends StatefulWidget {
  const PracticeListeningPage({Key? key}) : super(key: key);

  @override
  State<PracticeListeningPage> createState() => _PracticeListeningPageState();
}

class _PracticeListeningPageState extends State<PracticeListeningPage> {
  @override
  void deactivate() {
    context.read<CurrentLessonCubit>().dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CurrentLessonCubit>().load(context.read<ListeningListCubit>().state![0]);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.99),
      body: BlocBuilder<ListeningListCubit, List<Lesson>?>(
          builder: (context, state) => state == null
              ? const LoadingProgress()
              : Stack(
                  children: [
                    LessonListView(listLessons: state),
                    const AppbarPlayer()
                  ],
                )),
    );
  }
}
