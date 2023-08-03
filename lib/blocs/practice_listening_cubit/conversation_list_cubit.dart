import 'package:untitled/models/conversation.dart';
import 'package:untitled/models/kanji.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import '../../repositories/conversation_repository.dart';
import '../../repositories/kanji_repository.dart';
import 'package:just_audio/just_audio.dart';

class ConversationListCubit extends Cubit<List<Conversation>?> {
  ConversationListCubit() : super(null);
  final repo =  ConversationRepository.instance;
  final audioPlayer = AudioPlayer();
  void getData(Lesson lesson) async {
    var list = await repo.getAllConversations(lesson.id);
    emit(list);
  }

}