part of 'word_flashcard_cubit.dart';

abstract class WordFlashcardState extends Equatable {
  const WordFlashcardState();
}

class WordFlashcardInitial extends WordFlashcardState {
  @override
  List<Object> get props => [];
}

class WordFlashcardLoaded extends WordFlashcardState {
  const WordFlashcardLoaded({
    required this.indexCurrent,
    required this.listItems,
    required this.listIdHighLight,
  });

  final int indexCurrent;
  final List<Word> listItems;
  final List<String> listIdHighLight;

  WordFlashcardLoaded copyWith({
    int? indexCurrent,
    List<Word>? listItems,
    List<String>? listIdHighLight,
  }) {
    return WordFlashcardLoaded(
      indexCurrent: indexCurrent ?? this.indexCurrent,
      listItems: listItems ?? this.listItems,
      listIdHighLight: listIdHighLight ?? this.listIdHighLight,
    );
  }

  @override
  List<Object> get props => [
        indexCurrent,
        listItems,
        listIdHighLight,
      ];
}
