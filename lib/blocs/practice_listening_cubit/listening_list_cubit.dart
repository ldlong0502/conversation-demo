import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/repositories/lesson_repository.dart';


class ListeningListCubit extends Cubit<List<Lesson>?> {
  ListeningListCubit() : super(null);
  final repo = LessonRepository.instance;

  void getData() async {
    await repo.downloadFile();
    var list = await repo.getLessons();
    emit(list);
  }
}