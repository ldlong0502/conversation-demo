part of 'lesson_bloc.dart';


abstract class LessonState extends Equatable {
  const LessonState();
}

class LessonInitial extends LessonState {
  @override
  List<Object> get props => [];
}
class LessonLoading extends LessonState {
  @override
  List<Object> get props => [];
}

class LessonLoaded extends LessonState {
  final List<Lesson> listLessons;
  final bool isPlaying;
  final Lesson lessonPlaying;
  final AudioPlayer audioPlayer;
  const LessonLoaded({required this.listLessons , required this.isPlaying, required this.lessonPlaying, required this.audioPlayer});
  @override
  List<Object> get props => [listLessons , isPlaying, lessonPlaying, audioPlayer];
}

