part of 'word_practice_cubit.dart';

abstract class WordPracticeState extends Equatable {
  const WordPracticeState();
}

class WordPracticeInitial extends WordPracticeState {
  @override
  List<Object> get props => [];
}
class WordPracticeLoading extends WordPracticeState {
  @override
  List<Object> get props => [];
}
class WordPracticeLoaded extends WordPracticeState {

  const WordPracticeLoaded(
      {required this.isMuted,
        required this.isShowingDialog,
        required this.isClick,
        required this.indexCurrent,
        required this.listQuestion,
        required this.listHeart,
        required this.listAnswers,
        required this.heart,
        required this.startTime});

  final bool isMuted;
  final bool isShowingDialog;
  final bool isClick;
  final int indexCurrent;
  final List<Word> listQuestion;
  final List<bool> listHeart;
  final List<Map<String, dynamic>> listAnswers;
  final double startTime;
  final int heart;

  WordPracticeLoaded copyWith({
    bool? isMuted,
    bool? isShowingDialog,
    bool? isClick,
    int? indexCurrent,
    List<Word>? listQuestion,
    List<bool>? listHeart,
    List<Map<String, dynamic>>? listAnswers,
    double? startTime,
    int? heart,
  }) {
    return WordPracticeLoaded(
      isMuted: isMuted ?? this.isMuted,
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isClick: isClick ?? this.isClick,
      indexCurrent: indexCurrent ?? this.indexCurrent,
      listQuestion: listQuestion ?? this.listQuestion,
      listHeart: listHeart ?? this.listHeart,
      listAnswers: listAnswers ?? this.listAnswers,
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
    listAnswers,
    startTime,
    heart
  ];
}
