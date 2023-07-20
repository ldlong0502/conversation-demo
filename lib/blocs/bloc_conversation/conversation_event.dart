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

class UpdateTimeHighLight extends ConversationEvent {
  const UpdateTimeHighLight({required this.timeHighLight});
  final double timeHighLight;
  @override
  List<Object> get props => [timeHighLight];
}

class ConversationPlay extends ConversationEvent {
  const ConversationPlay({required this.isPlaying});
  final bool isPlaying;
  @override
  List<Object> get props => [isPlaying];
}
class UpdateItemHighLight extends ConversationEvent {
  const UpdateItemHighLight( {required this.isHighLight , required this.cons});
  final bool isHighLight;
  final Conversation cons;
  @override
  List<Object> get props => [isHighLight, cons];
}

class ClickItemConversation extends ConversationEvent {
  const ClickItemConversation({required this.start , required this.end});
  final double start;
  final double end;
  @override
  List<Object> get props => [start, end];
}

class UpdateActionMiddle extends ConversationEvent {
  const UpdateActionMiddle( {required this.index});
  final int index;
  @override
  List<Object> get props => [ index];
}