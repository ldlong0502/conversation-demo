part of 'list_word_cubit.dart';

abstract class ListWordState extends Equatable {
  const ListWordState();
}

class ListWordInitial extends ListWordState {
  @override
  List<Object> get props => [];
}
class ListWordLoaded extends ListWordState {
  const ListWordLoaded({required this.listWord , required this.word});
  final List<Word> listWord;
  final Word word;
  ListWordLoaded copyWith({
    List<Word>? listWord,
    Word? word,
  }) {
    return ListWordLoaded(
      listWord: listWord ?? this.listWord,
      word: word ?? this.word,
    );
  }
  @override
  List<Object> get props => [listWord,word];
}