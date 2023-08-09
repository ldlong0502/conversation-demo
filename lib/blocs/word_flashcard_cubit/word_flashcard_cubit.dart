
import 'package:untitled/repositories/word_repository.dart';
import '../../models/word.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'word_flashcard_state.dart';

class WordFlashcardCubit extends Cubit<WordFlashcardState> {
  WordFlashcardCubit() : super(WordFlashcardInitial());

  final repo = WordRepository.instance;
  void getData(List<Word> list)  async {
    List<Word> listItems =  List.from(list);
    listItems.shuffle();
    var listIdHighLight = await repo.getListWordFlashcard();
    emit(WordFlashcardLoaded(
        indexCurrent: 0,
        listItems: listItems,
        listIdHighLight: listIdHighLight));
  }

  void highLightFlashcard(Word word) async {
    if(state is WordFlashcardLoaded) {
      var stateNow = state as WordFlashcardLoaded;
      if(stateNow.listIdHighLight.contains(word.id.toString())){
        repo.removeWordFlashcardHighLight(word.id.toString());
      }
      else{
        repo.insertWordFlashcardHighLight(word.id.toString());
      }
      var listIdHighLight = await repo.getListWordFlashcard();
      emit(stateNow.copyWith(
        listIdHighLight: listIdHighLight
      ));
    }
  }
}
