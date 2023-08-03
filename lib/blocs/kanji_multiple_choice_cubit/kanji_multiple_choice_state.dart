part of 'kanji_multiple_choice_cubit.dart';

abstract class KanjiMultipleChoiceState extends Equatable {
  const KanjiMultipleChoiceState();
}

class KanjiMultipleChoiceInitial extends KanjiMultipleChoiceState {
  @override
  List<Object> get props => [];
}

class KanjiMultipleChoiceLoaded extends KanjiMultipleChoiceState {
  const KanjiMultipleChoiceLoaded({
    required this.isMuted,
    required this.isShowResult,
    required this.isClick,
    required this.indexCurrent,
    required this.listChoices,
    required this.listAnswersStatus,
    required this.historyAnswers,
  });

  final bool isMuted;
  final bool isShowResult;
  final bool isClick;
  final int indexCurrent;
  final List<Choice> listChoices;
  final List<String> listAnswersStatus;
  final List<Map<String, dynamic>> historyAnswers;

  KanjiMultipleChoiceLoaded copyWith({
    bool? isMuted,
    bool? isShowResult,
    bool? isClick,
    int? indexCurrent,
    List<Choice>? listChoices,
    List<String>? listAnswersStatus,
    List<Map<String, dynamic>>? historyAnswers,
  }) {
    return KanjiMultipleChoiceLoaded(
      isMuted: isMuted ?? this.isMuted,
      isShowResult: isShowResult ?? this.isShowResult,
      isClick: isClick ?? this.isClick,
      indexCurrent: indexCurrent ?? this.indexCurrent,
      listChoices: listChoices ?? this.listChoices,
      listAnswersStatus: listAnswersStatus ?? this.listAnswersStatus,
      historyAnswers: historyAnswers ?? this.historyAnswers,
    );
  }

  @override
  List<Object> get props => [
        isMuted,
        isShowResult,
        isClick,
        indexCurrent,
        listChoices,
        listAnswersStatus,
        historyAnswers
      ];
}
