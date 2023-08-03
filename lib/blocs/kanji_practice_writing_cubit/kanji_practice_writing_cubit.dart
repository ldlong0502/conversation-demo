import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/kanji.dart';

part 'kanji_practice_writing_state.dart';

class KanjiPracticeWritingCubit extends Cubit<KanjiPracticeWritingState> {
  KanjiPracticeWritingCubit() : super(KanjiPracticeWritingInitial());

  void loadKanji(Kanji kanji) {
    emit(KanjiPracticeWritingLoaded(kanji: kanji, isHideCoordinates: false));

  }
  void updateKanji(Kanji kanji) {
    if(state is KanjiPracticeWritingLoaded) {
      var stateNow = state as KanjiPracticeWritingLoaded;
      emit(KanjiPracticeWritingLoaded(kanji: kanji, isHideCoordinates: stateNow.isHideCoordinates));
    }
  }

  void updateIsHideCoordinates(){
    if(state is KanjiPracticeWritingLoaded) {
      var stateNow = state as KanjiPracticeWritingLoaded;
      emit(KanjiPracticeWritingLoaded(kanji: stateNow.kanji, isHideCoordinates: !stateNow.isHideCoordinates));
    }
  }
}
