
part of 'lesson_bloc.dart';

abstract class LessonEvent extends Equatable {
  const LessonEvent();
}
class GetAllLessons extends LessonEvent {
  const GetAllLessons();

  @override
  List<Object> get props => [];
}

class LessonListening extends LessonEvent {
  final Lesson lesson;
  const LessonListening({required this.lesson});
  @override
  List<Object> get props => [lesson];
}

class LessonStopped extends LessonEvent {

  @override
  List<Object> get props => [];
}

class LessonUpdateProgress extends LessonEvent {
  final Duration duration;
  const LessonUpdateProgress({required this.duration});
  @override
  List<Object> get props => [duration];
}

class LessonPlayNext extends LessonEvent {
  @override
  List<Object> get props => [];
}

class LessonInitAgain extends LessonEvent {
  final Lesson lesson;
  const LessonInitAgain({required this.lesson});
  @override
  List<Object> get props => [lesson];
}
class LessonUpdateDurationMax extends LessonEvent {
  final Lesson lesson;
  const LessonUpdateDurationMax({required this.lesson});
  @override
  List<Object> get props => [lesson];
}

class LessonDownloadMp3 extends LessonEvent {
  final Lesson lesson;
  const LessonDownloadMp3({required this.lesson});
  @override
  List<Object> get props => [lesson];
}