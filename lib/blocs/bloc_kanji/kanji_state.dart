part of 'kanji_bloc.dart';

abstract class KanjiState extends Equatable {
  const KanjiState();
}

class KanjiInitial extends KanjiState {
  @override
  List<Object> get props => [];
}
class KanjiLoading extends KanjiState {
  @override
  List<Object> get props => [];
}

class KanjiLoaded extends KanjiState {
  final List<Kanji> listKanjis;
  final List<Vocabulary> listVocs;
  final Kanji kanjiCurrent;
  final bool isHideActionPracticeWriting;
  const KanjiLoaded( {required this.listKanjis,required this.isHideActionPracticeWriting, required this.listVocs, required this.kanjiCurrent});
  @override
  List<Object> get props => [listKanjis, listVocs, kanjiCurrent , isHideActionPracticeWriting ];
}