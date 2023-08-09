
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/word.dart';
import '../../repositories/word_repository.dart';
import 'package:equatable/equatable.dart';

part 'list_word_state.dart';

class ListWordCubit extends Cubit<ListWordState> {
  ListWordCubit() : super(ListWordInitial());
  final repo = WordRepository.instance;

  void getData() async {
    await repo.downloadFile();
    var list = await repo.getWords();
    if(isClosed) {
      return;
    }
    emit(ListWordLoaded(listWord: list , word: list[0]));
  }
  
  void updateWord(Word word) {
    if(state is ListWordLoaded) {
      var stateNow = state as ListWordLoaded;
      emit(stateNow.copyWith(
        word: word
      ));
    }
  }
}
