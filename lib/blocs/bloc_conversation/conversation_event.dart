part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
}
class GetAllConversations extends ConversationEvent {
  const GetAllConversations({required this.idLesson});
  final int idLesson;
  @override
  List<Object> get props => [idLesson];
}