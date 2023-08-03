import 'package:untitled/models/kanji.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/kanji_repository.dart';

class ListKanjiCubit extends Cubit<List<Kanji>?> {
  ListKanjiCubit() : super(null);
  final repo = KanjiRepository.instance;

  void getData() async {
    var list = await repo.getAllKanjis();
    list.sort((a, b) => (int.parse(a.order1).compareTo(int.parse(b.order1))));
    var newList = <Kanji>[];
    for (var item in list) {
      if (await repo.checkKanjiHighLight(item.id)) {
        newList.add(item.copyWith(isHighLight: true));
      } else {
        newList.add(item);
      }
    }
    emit(newList);
  }

  updateKanjiHighLight(Kanji kanji)  async {
    if(state != null) {
      if(kanji.isHighLight){
        await repo.removeKanjiHighLight(kanji.id);
      }
      else {
        await repo.insertKanjiHighLight(kanji.id);
      }
      var list = state!.map((e) {
        if(e.id == kanji.id){
          return e.copyWith(isHighLight: !e.isHighLight);
        }
        return e;
      }).toList();
      emit(list);
    }
  }
}