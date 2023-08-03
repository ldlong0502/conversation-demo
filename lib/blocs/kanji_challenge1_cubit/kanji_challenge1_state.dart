part of 'kanji_challenge1_cubit.dart';

abstract class KanjiChallenge1State extends Equatable {
  const KanjiChallenge1State();
}

class KanjiChallenge1Initial extends KanjiChallenge1State {
  @override
  List<Object> get props => [];
}

class KanjiChallenge1Loaded extends KanjiChallenge1State {
  const KanjiChallenge1Loaded(
      {required this.isMuted,
      required this.isShowingDialog,
      required this.isClick,
      required this.indexCurrent,
      required this.listQuestion,
      required this.listHeart,
      required this.listDataAnswer,
      required this.heart,
      required this.startTime});

  final bool isMuted;
  final bool isShowingDialog;
  final bool isClick;
  final int indexCurrent;
  final List<Kanji> listQuestion;
  final List<bool> listHeart;
  final List<Map<String, dynamic>> listDataAnswer;
  final double startTime;
  final int heart;

  KanjiChallenge1Loaded copyWith({
    bool? isMuted,
    bool? isShowingDialog,
    bool? isClick,
    int? indexCurrent,
    List<Kanji>? listQuestion,
    List<bool>? listHeart,
    List<Map<String, dynamic>>? listDataAnswer,
    double? startTime,
    int? heart,
  }) {
    return KanjiChallenge1Loaded(
      isMuted: isMuted ?? this.isMuted,
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isClick: isClick ?? this.isClick,
      indexCurrent: indexCurrent ?? this.indexCurrent,
      listQuestion: listQuestion ?? this.listQuestion,
      listHeart: listHeart ?? this.listHeart,
      listDataAnswer: listDataAnswer ?? this.listDataAnswer,
      startTime: startTime ?? this.startTime,
      heart: heart ?? this.heart,
    );
  }

  @override
  List<Object> get props => [
        isMuted,
        isShowingDialog,
        isClick,
        indexCurrent,
        listQuestion,
        listHeart,
        listDataAnswer,
        startTime,
        heart
      ];
}
