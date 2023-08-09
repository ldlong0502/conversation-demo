import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/listening_list_cubit.dart';
import 'package:untitled/features/listening/appbar_player.dart';
import 'package:untitled/features/listening/lesson_list_view.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/widgets/loading_progress.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/position_data.dart';
import '../../repositories/download_repository.dart';
import '../../services/sound_service.dart';

class PracticeListeningPage extends StatefulWidget {
  const PracticeListeningPage({Key? key}) : super(key: key);

  @override
  State<PracticeListeningPage> createState() => _PracticeListeningPageState();
}

class _PracticeListeningPageState extends State<PracticeListeningPage> {
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
  @override
  void initState() {
    soundService.newPlayer();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    soundService.stop();
  }
  @override
  Widget build(BuildContext context) {
    DownloadRepository.instance.setContext(context);
    return BlocProvider(
      create: (context) => ListeningListCubit()..getData(),
      child: BlocBuilder<ListeningListCubit, List<Lesson>?>(
          builder: (context, listLessons) => listLessons == null
              ? const Scaffold(body: LoadingProgress())
              : BlocProvider(
                  create: (context) =>
                      CurrentLessonCubit(context)..load(listLessons[0]),
                  child: BlocBuilder<CurrentLessonCubit, Lesson?>(
                    builder: (context, state) {
                      if(state == null) return const LoadingProgress();
                      return Scaffold(
                        appBar:  PreferredSize(
                          preferredSize: const Size.fromHeight(180),
                          child: AppbarPlayer(
                            positionDataSteam: positionDataSteam,
                          ),
                        ),
                        body: LessonListView(
                            listLessons: listLessons),
                      );
                    },
                  ),
                )),
    );
  }
}
