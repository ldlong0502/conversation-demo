import 'package:untitled/models/kanji.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import '../../repositories/kanji_repository.dart';

class ListeningListCubit extends Cubit<List<Lesson>?> {
  ListeningListCubit() : super(null);
  final repo = LessonRepository.instance;

  void getData() async {
    var list = await repo.getAllLessons();

    emit(list);
  }
}