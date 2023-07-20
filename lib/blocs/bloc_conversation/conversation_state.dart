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
  final double timePosition;
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final bool isBlur;
  final bool isSpeed;
  final bool isTranslate;
  final bool isPhonetic;

  const ConversationLoaded(
      {required this.listConversations,
      required this.audioPlayer,
      required this.isPlaying,
      required this.timePosition,
      required this.isBlur,
      required this.isPhonetic,
      required this.isSpeed,
      required this.isTranslate});

  @override
  List<Object> get props => [
        listConversations,
        timePosition,
        audioPlayer,
        isPlaying,
        isBlur,
        isPhonetic,
        isTranslate,
        isSpeed
      ];
}
