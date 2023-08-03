import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/repositories/kanji_repository.dart';
import '../../models/kanji.dart';
import '../../models/vocabulary.dart';
import '../../utils/split_text.dart';



class KanjiVocabularyCubit extends Cubit<List<Vocabulary>?> {
  KanjiVocabularyCubit() : super(null);
  final repo = KanjiRepository.instance;
  void updateKanji(Kanji kanji) async {
    final listIntVoc =
    SplitText().extractVocabularies(kanji.vocabularies);
    var list = await KanjiRepository.instance.getVocabularies(listIntVoc);
    emit(list);
  }


}
