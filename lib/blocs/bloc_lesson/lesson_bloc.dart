import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/lesson.dart';
import '../../repositories/audio_helper.dart';
import 'package:async/async.dart';
part 'lesson_event.dart';

part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final lessonRepo = LessonRepository.instance;
  AudioPlayer audioPlayer = AudioPlayer();
  CancelableOperation?  _sub;
  LessonBloc() : super(LessonInitial()) {
    on<GetAllLessons>((event, emit) async {
      try {
        var list = await lessonRepo.getAllLessons();

        // list = await Future.wait(list.map((e) async {
        //   final duration = await AudioHelper.instance.getDuration(e.mp3);
        //   return e.copyWith(durationMax: duration);
        // }));
        emit(LessonLoaded(
            listLessons: list,
            isPlaying: false,
            lessonPlaying: list[0],
            audioPlayer: audioPlayer));
      } catch (e) {
        print(e);
      }
    });
    Future<Duration> _loadData(Lesson lesson) async {
      return await AudioHelper.instance.getDuration(lesson.mp3);
    }
    on<LessonDownloadMp3>((event, emit) async {
      try {
        if (state is LessonLoaded) {
          if(_sub != null) {
            final result = await _sub?.cancel();
            if(result != null)
            {
              await File(await AudioHelper.instance.getPathFileAudio(result)).delete(recursive: true);
            }

          }
          var stateNow = state as LessonLoaded;
          print( 'long'+ stateNow.lessonPlaying.id.toString());
          _sub = CancelableOperation.fromFuture(
            _loadData(event.lesson),
            onCancel: () => event.lesson.mp3,
          );
          final duration = await _sub?.value;
          _sub = null;
          final list = (state
          as LessonLoaded).listLessons.map((e)  {
            if (e.id == event.lesson.id) {
              print(55555);
              return e.copyWith( isPlaying: true, isLoading:false ,durationMax: duration);
            } else {
              return e;
            }
          }).toList();
          final item =
          list.firstWhere((element) => element.id == event.lesson.id);
          emit(LessonLoaded(
              listLessons: list,
              isPlaying: true,
              lessonPlaying: item,
              audioPlayer: audioPlayer));
          final pathAudio =
          await AudioHelper.instance.getPathFileAudio(event.lesson.mp3);
          await audioPlayer.setFilePath(pathAudio,
              initialPosition: event.lesson.durationCurrent);
          await audioPlayer.play();
        }
      } catch (e) {
        print(e);
      }
    });
    on<LessonListening>((event, emit) async {
      try {
        if (state is LessonLoaded) {
          print(111);
          var list = (state as LessonLoaded).listLessons.map((e)  {
            if (e.id == event.lesson.id) {
              // final duration = await AudioHelper.instance.getDuration(e.mp3);
              return e.copyWith(isPlaying: true , isLoading: true);
            } else {
              return e.copyWith(
                  isPlaying: false,
                  durationCurrent: const Duration(seconds: 0));
            }
          }).toList();
          final item =
          list.firstWhere((element) => element.id == event.lesson.id);
          emit(LessonLoaded(
              listLessons: list,
              isPlaying: true,
              lessonPlaying: item,
              audioPlayer: audioPlayer));
          // final pathAudio =
          //     await AudioHelper.instance.getPathFileAudio(event.lesson.mp3);
          // await audioPlayer.setFilePath(pathAudio,
          //     initialPosition: event.lesson.durationCurrent);
          // await audioPlayer.play();
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
          final duration = await AudioHelper.instance.getDuration(lessonNow.mp3);
           list = list.map((e) {
            if (e.id == lessonNow.id) {
              return e.copyWith(durationMax: duration);
            } else {
              return e;
            }
          }).toList();
          emit(LessonLoaded(
              listLessons: list,
              isPlaying: true,
              lessonPlaying: lessonNow.copyWith(durationMax: duration),
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

    on<LessonInitAgain>((event, emit) async {
      try {
        if (state is LessonLoaded) {
          var stateNow = state as LessonLoaded;
          var list = stateNow.listLessons.map((e) {
            return e.copyWith(
                isPlaying: false, durationCurrent: const Duration(seconds: 0));
          }).toList();

          final item =
              list.firstWhere((element) => element.id == event.lesson.id);
          emit(LessonLoaded(
              listLessons: list,
              isPlaying: false,
              lessonPlaying: item,
              audioPlayer: audioPlayer));
        }
      } catch (e) {
        print(e);
      }
    });

    on<LessonUpdateDurationMax>((event, emit) async {
      try {
        if (state is LessonLoaded) {
          var stateNow = state as LessonLoaded;
          var list = await  Future.wait((state as LessonLoaded).listLessons.map((e) async {
            if (e.id == event.lesson.id) {
              final duration = await AudioHelper.instance.getDuration(e.mp3);
              return e.copyWith(durationMax: duration);
            } else {
              return e.copyWith(
                  durationCurrent: const Duration(seconds: 0));
            }
          }).toList());
          final item =
          list.firstWhere((element) => element.id == event.lesson.id);
          emit(LessonLoaded(
              listLessons: list,
              isPlaying: false,
              lessonPlaying: item,
              audioPlayer: audioPlayer));
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
