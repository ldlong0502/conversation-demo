
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import '../../repositories/audio_helper.dart';
import 'package:just_audio/just_audio.dart';

import 'listening_list_cubit.dart';
class CurrentLessonCubit extends Cubit<Lesson?> {
  CurrentLessonCubit(this.context) : super(null);
  final BuildContext context;
  bool isClosed = false;
  bool isPaused = false;
  var audioPlayer = AudioPlayer();
  final repo = LessonRepository.instance;
  void load(Lesson lesson) async {
    audioPlayer = AudioPlayer();
    emit(lesson);
  }
  void play() async {
    isPaused = false;
    audioPlayer.setVolume(1);
    if(isClosed) return;
    emit(state!.copyWith(isLoading: true));
    var duration = const Duration(seconds: 0);
    if(state!.durationMax.inSeconds == 0)
    {
      duration =  await AudioHelper.instance.getDuration(state!.mp3);
    }
    else {
      duration = state!.durationMax;
    }

    if(isClosed) return;
    emit(state!.copyWith(
      isPlaying: true,
      isLoading: false,
      durationMax: duration
    ));

    final pathAudio =
    await AudioHelper.instance.getPathFileAudio(state!.mp3);
    await audioPlayer.setFilePath(pathAudio,
        initialPosition: state!.durationCurrent);
    audioPlayer.positionStream.listen((position) {
      if(state!.isPlaying && !isClosed)
      {
        emit(state!.copyWith(durationCurrent: position));
      }

      if(position.inMilliseconds >= state!.durationMax.inMilliseconds) {
        playNext();
      }
    });
    if(isPaused) {
      pause();
      return;
    }
    await audioPlayer.play();

  }
  playOtherItem(Lesson newLesson) async {
    await audioPlayer.stop();
    emit(newLesson.copyWith(
        durationCurrent: const Duration(seconds: 0)
    ));
    play();
  }
  void pause () async {
    isPaused = true;
    emit(state!.copyWith(
      isPlaying: false,
    ));
    audioPlayer.setVolume(0);
    audioPlayer.pause();
  }

  void dispose() async {
    audioPlayer.dispose();
    isClosed = true;
  }

  void playNext() {
    var listLessons = context.read<ListeningListCubit>().state!;
    final index = listLessons.indexWhere((element) => element.id == state!.id);
    final nextIndex = index + 1 == listLessons.length ? 0 : index + 1;
    playOtherItem(listLessons[nextIndex]);
  }
}