import 'package:untitled/models/kanji.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import '../../repositories/audio_helper.dart';
import '../../repositories/kanji_repository.dart';
import 'package:just_audio/just_audio.dart';
class CurrentLessonCubit extends Cubit<Lesson?> {
  CurrentLessonCubit() : super(null);
  final audioPlayer = AudioPlayer();
  final repo = LessonRepository.instance;

  void load(Lesson lesson) async {
    emit(lesson);
  }
  void play() async {
    audioPlayer.setVolume(1);
    emit(state!.copyWith(isLoading: true));
    var duration = const Duration(seconds: 0);
    if(state!.durationMax.inSeconds == 0)
    {
      duration =  await AudioHelper.instance.getDuration(state!.mp3);
    }
    else {
      duration = state!.durationMax;
    }
    emit(state!.copyWith(
      isPlaying: true,
      isLoading: false,
      durationMax: duration
    ));
    final pathAudio =
    await AudioHelper.instance.getPathFileAudio(state!.mp3);
    await audioPlayer.setFilePath(pathAudio,
        initialPosition: state!.durationCurrent);
    audioPlayer.positionStream.listen((event) {
      if(state!.isPlaying)
      {
        emit(state!.copyWith(durationCurrent: event));
      }
    });
    await audioPlayer.play();

  }
  playOtherItem(Lesson newLesson) async {
    await audioPlayer.stop();
    emit(newLesson.copyWith(
        durationCurrent: const Duration(seconds: 0)
    ));
    play();
  }
  Future pause () async {
    audioPlayer.setVolume(0);
    audioPlayer.pause();
    emit(state!.copyWith(
        isPlaying: false,

    ));


    Future.delayed(const Duration(seconds: 3));
  }

  void dispose() {
    audioPlayer.setVolume(0);
    emit(state!.copyWith(
      isPlaying: false,
    ));
    audioPlayer.stop();
  }
}