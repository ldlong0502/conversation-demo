import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/repositories/kanji_repository.dart';
import '../../models/kanji.dart';

part 'kanji_state.dart';

class KanjiCubit extends Cubit<Kanji?> {
  KanjiCubit() : super(null);
  bool isClose = false;
  final repo = KanjiRepository.instance;
  void updateKanji(Kanji kanji) => emit(kanji);

  void updateKanjiHighLight()  async {
   if(state != null) {
    if(state!.isHighLight){
      await repo.removeKanjiHighLight(state!.id);
    }
    else {
      await repo.insertKanjiHighLight(state!.id);
    }
     emit(state!.copyWith(isHighLight: !state!.isHighLight));
   }
  }

  void closeCubit() {
    isClose = true;
    close();
  }


}
