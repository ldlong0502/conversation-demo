import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/conversation.dart';
import '../../repositories/conversation_repository.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationInitial()) {
    final consRepo =  ConversationRepository.instance;
    on<GetAllConversations>((event, emit)  async {
      try {
        var list = await consRepo.getAllLessons(event.idLesson);
        emit(ConversationLoaded(
            listConversations: list));
      } catch (e) {
        print(e);
      }
    });
  }
}
