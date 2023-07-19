
part of 'conversation_bloc.dart';
abstract class ConversationState extends Equatable {
  const ConversationState();
}

class ConversationInitial extends ConversationState {
  @override
  List<Object> get props => [];
}
class ConversationLoading extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationLoaded extends ConversationState {
  final List<Conversation> listConversations;

  const ConversationLoaded({required this.listConversations});
  @override
  List<Object> get props => [listConversations];
}