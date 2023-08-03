import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/blocs/list_kanji_cubit/list_kanji_cubit.dart';
import 'package:untitled/repositories/kanji_repository.dart';

import '../../models/kanji.dart';
import '../../repositories/api_helper.dart';
import '../../utils/split_text.dart';

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
  Future getVocs() async {

    if(state != null) {
      final listIntVoc =
      SplitText().extractVocabularies(state!.vocabularies);
      var list = await KanjiRepository.instance.getVocabularies(listIntVoc);



      emit(state!.copyWith(
          listVocs: list));
    }
  }

  Future getImageUsage(BuildContext context) async {

    if(state != null) {

      final lookAndLearn = await repo.getLookAndLearnById(state!.order1);

      final pathImage = await ApiHelper.instance.getPathFileImageUsageKanji(state!.order1, context);
      if(isClose) return;
      emit(state!.copyWith(
          lookAndLearn: lookAndLearn.copyWith(imageUrl: pathImage)));
    }
  }
}
