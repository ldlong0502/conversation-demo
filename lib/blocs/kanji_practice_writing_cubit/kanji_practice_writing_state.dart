part of 'kanji_practice_writing_cubit.dart';

abstract class KanjiPracticeWritingState extends Equatable {
  const KanjiPracticeWritingState();
}

class KanjiPracticeWritingInitial extends KanjiPracticeWritingState {
  @override
  List<Object> get props => [];
}
class KanjiPracticeWritingLoaded extends KanjiPracticeWritingState {
  const KanjiPracticeWritingLoaded({required this.kanji , required this.isHideCoordinates });
  final Kanji kanji;
  final bool isHideCoordinates;
  @override
  List<Object> get props => [kanji,isHideCoordinates];
}
