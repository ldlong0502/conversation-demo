import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/models/word.dart';
import '../../enums/status_answer.dart';
import '../../services/sound_service.dart';

part 'word_practice_state.dart';

class WordPracticeCubit extends Cubit<WordPracticeState> {
  WordPracticeCubit() : super(WordPracticeInitial());

  void getData(List<Word> listWord) {
    List<Word> shuffledList = List.from(listWord)..shuffle();
    var listAns = getListAnswers( shuffledList, 0);
    emit(WordPracticeLoaded(
        isMuted: false,
        isShowingDialog: false,
        isClick: false,
        indexCurrent: 0,
        listQuestion: shuffledList,
        listHeart: const [true, true, true],
        listAnswers: listAns,
        heart: 3,
        startTime: 5));
  }

  getListAnswers(List<Word> listWord , int i) {
    var shuffledList = List.of(listWord)..shuffle(
    );
    var differentWords = shuffledList.where((word) => word.id != listWord[i].id)
        .take(3)
        .toList();
    differentWords.add(listWord[i]);

    differentWords.shuffle();

    return differentWords.map((e) => {
      'item': e,
      'status': StatusAnswer.normal
    }).toList();
  }

  onClick(int index) {
    if (state is WordPracticeLoaded) {
      var stateNow = state as WordPracticeLoaded;
      if (stateNow.isClick) return;
      var heart = stateNow.heart;
      var listAnswers = List.of(stateNow.listAnswers);
      var listHeart = List.of(stateNow.listHeart);
      if (index == -1) {
        playAudio(false);
        heart--;
        listHeart[heart] = false;
        final trueIndex = listAnswers.indexWhere((e) =>
        e['item'].word ==
            stateNow.listQuestion[stateNow.indexCurrent].word);
        listAnswers[trueIndex]['status'] = StatusAnswer.right;
      } else {
        if (stateNow.listQuestion[stateNow.indexCurrent].word ==
            stateNow.listAnswers[index]['item'].word) {
          playAudio(true);
          listAnswers[index]['status'] = StatusAnswer.right;
        } else {
          playAudio(false);
          heart--;
          listHeart[heart] = false;
          listAnswers[index]['status'] = StatusAnswer.wrong;
          final trueIndex = stateNow.listAnswers.indexWhere((e) =>
          e['item'].word ==
              stateNow.listQuestion[stateNow.indexCurrent].word);
          listAnswers[trueIndex]['status'] = StatusAnswer.right;
        }
      }

      if (heart == 0) {
        emit(stateNow.copyWith(
            heart: heart,
            listHeart: listHeart,
            isClick: true,
            isShowingDialog: true));
      } else {

        var list = listAnswers.map((e)  {
          if(e['status'] == StatusAnswer.normal)
            {
              return {
                'item': e['item'],
                'status': StatusAnswer.old };
            }
          else {
            return e;
          }
        }).toList();
        emit(stateNow.copyWith(
            isClick: true,
            listAnswers: list,
            heart: heart,
            listHeart: listHeart));
        Future.delayed(const Duration(seconds: 1))
            .then((value) => nextQuestion());
      }
    }
  }
  FutureOr nextQuestion()  {
    if (state is WordPracticeLoaded) {
      var stateNow = state as WordPracticeLoaded;
      if (stateNow.indexCurrent + 1 == stateNow.listQuestion.length) {
        emit(stateNow.copyWith(isShowingDialog: true));
      } else {
        int nextIndex = stateNow.indexCurrent + 1;
        var listAnswer = getListAnswers(stateNow.listQuestion, nextIndex);


        emit(stateNow.copyWith(
            indexCurrent: stateNow.indexCurrent + 1,
            startTime: 5,
            listAnswers: listAnswer,
            isClick: false));
      }
    }
  }
  void countTimer() {
    if (state is WordPracticeLoaded) {
      var stateNow = state as WordPracticeLoaded;
      if (stateNow.isClick) return;
      if (stateNow.startTime == 0) {
        onClick(-1);
        return;
      }
      emit(stateNow.copyWith(startTime: stateNow.startTime - 0.5));
    }
  }

  onDoAgain() {
    if (state is WordPracticeLoaded) {
      final stateNow = state as WordPracticeLoaded;
      var listQuestion = stateNow.listQuestion;
      listQuestion.shuffle();

      var listAnswers = getListAnswers(listQuestion, 0);
      emit(stateNow.copyWith(
        listQuestion: listQuestion,
        isShowingDialog: false,
        isClick: false,
        listAnswers: listAnswers,
        indexCurrent: 0,
        listHeart: const [true, true, true],
        heart: 3,
        startTime: 5,
      ));
    }
  }

  void playAudio(bool answer) {
    if(answer) {
      SoundService.instance.playAsset('assets/audios/right.mp3');
    }
    else{
      SoundService.instance.playAsset('assets/audios/wrong.mp3');
    }
  }
}
