import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/repositories/kanji_repository.dart';

import '../../models/choice.dart';
import 'package:just_audio/just_audio.dart';

part 'kanji_multiple_choice_state.dart';

class KanjiMultipleChoiceCubit extends Cubit<KanjiMultipleChoiceState> {
  KanjiMultipleChoiceCubit() : super(KanjiMultipleChoiceInitial());
  final repo = KanjiRepository.instance;
  final AudioPlayer audioPlayer = AudioPlayer();

  void getData() async {
    var listChoices = await KanjiRepository.instance.getChoices();
    listChoices.shuffle();
    emit(KanjiMultipleChoiceLoaded(
        isMuted: false,
        isShowResult: false,
        isClick: false,
        indexCurrent: 0,
        listChoices: listChoices,
        listAnswersStatus: const ['none', 'none', 'none', 'none'],
        historyAnswers: const []));
  }
  void onDoAgain() {
    if (state is KanjiMultipleChoiceLoaded) {
      final stateNow = state as KanjiMultipleChoiceLoaded;
      var listChoices = stateNow.listChoices;
      listChoices.shuffle();
      emit(stateNow.copyWith(
          isShowResult: false,
          isClick: false,
          indexCurrent: 0,
          listChoices: listChoices,
          listAnswersStatus: const ['none', 'none', 'none', 'none'],
          historyAnswers: const []));
    }
  }
  void clickAnswer(int index, int indexAnswer) async {
    if (state is KanjiMultipleChoiceLoaded) {
      final stateNow = state as KanjiMultipleChoiceLoaded;
      if (stateNow.isClick) return;
      var list = stateNow.listAnswersStatus.map((e) {
        return 'isClick';
      }).toList();
      var isAnswerRight = index == indexAnswer;
      if (isAnswerRight) {
        playAudio(true);
        list[index] = 'true';
      } else {
        playAudio(false);
        list[index] = 'false';
        list[indexAnswer] = 'true';
      }
      var historyList = List.of(stateNow.historyAnswers);
      historyList.add({
        'title': stateNow.listChoices[stateNow.indexCurrent].title,
        'answer': isAnswerRight
      });
      emit(stateNow.copyWith(
          isClick: true, listAnswersStatus: list, historyAnswers: historyList));
      await Future.delayed(const Duration(seconds: 1))
          .then((value) => nextQuestion());
    }
  }

  void playAudio(bool answer) {
    if (answer) {
      audioPlayer.setAsset('assets/audios/right.mp3').then((_) {
        audioPlayer.play();
      });
    } else {
      audioPlayer.setAsset('assets/audios/wrong.mp3').then((_) {
        audioPlayer.play();
      });
    }
  }
  void mute() {
    if (state is KanjiMultipleChoiceLoaded) {
      final stateNow = state as KanjiMultipleChoiceLoaded;
      if(stateNow.isMuted) {
        audioPlayer.setVolume(1);
      } else {
        audioPlayer.setVolume(0);
      }
      emit(stateNow.copyWith(isMuted: !stateNow.isMuted));
    }

  }
  nextQuestion() {
    if (state is KanjiMultipleChoiceLoaded) {
      final stateNow = state as KanjiMultipleChoiceLoaded;
      bool isShowResult = false;
      if (stateNow.indexCurrent + 1 >= stateNow.listChoices.length) {
        isShowResult = true;
      }
      var list = stateNow.listAnswersStatus.map((e) => 'none').toList();
      emit(stateNow.copyWith(
        listAnswersStatus: list,
        indexCurrent: stateNow.indexCurrent + 1,
        isShowResult: isShowResult,
        isClick: false
      ));
    }
  }
}
