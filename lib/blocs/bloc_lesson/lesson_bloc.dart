import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/lesson.dart';
import '../../repositories/audio_helper.dart';

part 'lesson_event.dart';

part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final lessonRepo = LessonRepository.instance;
  AudioPlayer audioPlayer = AudioPlayer();

  LessonBloc() : super(LessonInitial()) {
    on<GetAllLessons>((event, emit) async {
      try {
        var list = await lessonRepo.getAllLessons();
        final duration = await AudioHelper.instance.getDuration('test');
        list = list.map((e) => e.copyWith(durationMax: duration)).toList();
        emit(LessonLoaded(
            listLessons: list,
            isPlaying: false,
            lessonPlaying: list[0],
            audioPlayer: audioPlayer));
      } catch (e) {
        print(e);
      }
    });

    on<LessonListening>((event, emit) async {
      try {
        if (state is LessonLoaded) {
          print(111);
          var list = (state as LessonLoaded).listLessons.map((e) {
            if (e.id == event.lesson.id) {
              return e.copyWith(isPlaying: true);
            } else {
              return e.copyWith(
                  isPlaying: false,
                  durationCurrent: const Duration(seconds: 0));
            }
          }).toList();
          emit(LessonLoaded(
              listLessons: list,
              isPlaying: true,
              lessonPlaying: event.lesson,
              audioPlayer: audioPlayer));
          final pathAudio =
              await AudioHelper.instance.getPathFileAudio(event.lesson.mp3);
          await audioPlayer.setFilePath(pathAudio,
              initialPosition: event.lesson.durationCurrent);
          await audioPlayer.setSpeed(5);
          await audioPlayer.play();
        }
      } catch (e) {
        print(e);
        print(777);
      }
    });

    on<LessonStopped>((event, emit) async {
      try {
        if (state is LessonLoaded) {
          print('stop');
          await audioPlayer.stop();
          var stateNow = state as LessonLoaded;
          var list = (state as LessonLoaded).listLessons.map((e) {
            if (e.id == stateNow.lessonPlaying.id) {
              return e.copyWith(
                  isPlaying: false, durationCurrent: audioPlayer.position);
            } else {
              return e.copyWith(
                  isPlaying: false,
                  durationCurrent: const Duration(seconds: 0));
            }
          }).toList();
          final lessonNow = list
              .firstWhere((element) => element.id == stateNow.lessonPlaying.id);
          emit(LessonLoaded(
              listLessons: list,
              isPlaying: false,
              lessonPlaying: lessonNow,
              audioPlayer: audioPlayer));
        }
      } catch (e) {
        print(e);
      }
    });

    on<LessonUpdateProgress>((event, emit) async {
      try {
        if (state is LessonLoaded) {
          var stateNow = state as LessonLoaded;
          var list = stateNow.listLessons.map((e) {
            if (e.id == stateNow.lessonPlaying.id) {
              return e.copyWith(durationCurrent: event.duration);
            } else {
              return e;
            }
          }).toList();
          final lessonNow = list
              .firstWhere((element) => element.id == stateNow.lessonPlaying.id);
          emit(LessonLoaded(
              listLessons: list,
              isPlaying: true,
              lessonPlaying: lessonNow,
              audioPlayer: audioPlayer));
          // if(event.duration == stateNow.lessonPlaying.durationMax) {
          //   var list = stateNow.listLessons.map((e) {
          //     return e.copyWith(isPlaying: false, durationCurrent: const Duration(seconds: 0));
          //   }).toList();
          //
          //   int currentIndex = list.indexWhere((e) => e.id == stateNow.lessonPlaying.id);
          //   int nextIndex = currentIndex + 1 < list.length ? currentIndex +1 : 0;
          //   list[nextIndex].isPlaying = true;
          //   final lessonNow = list[nextIndex];
          //
          //   emit(LessonLoaded(listLessons:  list, isPlaying: true , lessonPlaying: lessonNow, audioPlayer: audioPlayer));
          //   final pathAudio = await AudioHelper.instance.getPathFileAudio(lessonNow.mp3);
          //   await audioPlayer.setFilePath(pathAudio , initialPosition:  lessonNow.durationCurrent);
          //   await audioPlayer.play();
          // }
          // else {
          //
          // }
        }
      } catch (e) {
        print(e);
      }
    });

    on<LessonPlayNext>((event, emit) async {
      try {
        if (state is LessonLoaded) {
          var stateNow = state as LessonLoaded;
          var list = stateNow.listLessons.map((e) {
            return e.copyWith(
                isPlaying: false, durationCurrent: const Duration(seconds: 0));
          }).toList();

          int currentIndex =
              list.indexWhere((e) => e.id == stateNow.lessonPlaying.id);
          int nextIndex = currentIndex + 1 < list.length ? currentIndex + 1 : 0;
          list[nextIndex].isPlaying = true;
          final lessonNow = list[nextIndex];

          emit(LessonLoaded(
              listLessons: list,
              isPlaying: true,
              lessonPlaying: lessonNow,
              audioPlayer: audioPlayer));
          final pathAudio =
              await AudioHelper.instance.getPathFileAudio(lessonNow.mp3);
          await audioPlayer.setFilePath(pathAudio,
              initialPosition: lessonNow.durationCurrent);
          await audioPlayer.play();
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
