part of 'kanji_bloc.dart';

abstract class KanjiEvent extends Equatable {
  const KanjiEvent();
}
class GetAllKanjis extends KanjiEvent {
  const GetAllKanjis();
  @override
  List<Object> get props => [];
}
class UpdateKanjiCurrent extends KanjiEvent {
  const UpdateKanjiCurrent({required this.kanji});
  final Kanji kanji;
  @override
  List<Object> get props => [kanji];
}
class UpdateListVocabularies extends KanjiEvent {
  const UpdateListVocabularies({required this.kanji, required this.context});
  final Kanji kanji;
  final BuildContext context;
  @override
  List<Object> get props => [kanji,context];
}
class HighLightCurrentKanji extends KanjiEvent {
  const HighLightCurrentKanji();
  @override
  List<Object> get props => [];
}
class ChangeFirstItem extends KanjiEvent {
  const ChangeFirstItem();
  @override
  List<Object> get props => [];
}

class HideActionClick extends KanjiEvent {
  const HideActionClick();
  @override
  List<Object> get props => [];
}

class UpdateUsageDetail extends KanjiEvent {
  const UpdateUsageDetail({Key? key, required this.context});
  final BuildContext context;
  @override
  List<Object> get props => [context];
}