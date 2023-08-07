import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/listening_list_cubit.dart';
import 'package:untitled/features/listening/appbar_player.dart';
import 'package:untitled/features/listening/lesson_list_view.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/widgets/loading_progress.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import '../blocs/practice_listening_cubit/conversation_player_cubit.dart';
import '../models/position_data.dart';

class PracticeListeningPage extends StatefulWidget {
  const PracticeListeningPage({Key? key}) : super(key: key);

  @override
  State<PracticeListeningPage> createState() => _PracticeListeningPageState();
}

class _PracticeListeningPageState extends State<PracticeListeningPage> {
  final audioPlayer = AudioPlayer();

  Stream<PositionData> get positionDataSteam =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              duration: duration ?? Duration.zero,
              bufferedPosition: bufferedPosition));
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListeningListCubit()..getData(),
      child: BlocBuilder<ListeningListCubit, List<Lesson>?>(
          builder: (context, listLessons) => listLessons == null
              ? const Scaffold(body: LoadingProgress())
              : BlocProvider(
                  create: (context) =>
                      CurrentLessonCubit(context)..load(listLessons![0]),
                  child: BlocBuilder<CurrentLessonCubit, Lesson?>(
                    builder: (context, state) {
                      return Scaffold(
                        appBar:  PreferredSize(
                          preferredSize: const Size.fromHeight(180),
                          child: AppbarPlayer(
                            audioPlayer: audioPlayer,
                            positionDataSteam: positionDataSteam,
                          ),
                        ),
                        body: LessonListView(
                            audioPlayer: audioPlayer,
                            listLessons: listLessons!),
                      );
                    },
                  ),
                )),
    );
  }
}
