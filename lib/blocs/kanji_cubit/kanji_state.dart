part of 'kanji_cubit.dart';

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
   const KanjiLoaded({required this.listKanjis});
  @override
  List<Object> get props => [listKanjis];
}

