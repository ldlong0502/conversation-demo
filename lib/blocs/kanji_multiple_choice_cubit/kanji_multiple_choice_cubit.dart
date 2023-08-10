import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/models/vocabulary_kanji.dart';
import 'package:untitled/repositories/kanji_repository.dart';

import '../../models/choice.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/kanji.dart';

part 'kanji_multiple_choice_state.dart';

class KanjiMultipleChoiceCubit extends Cubit<KanjiMultipleChoiceState> {
  KanjiMultipleChoiceCubit() : super(KanjiMultipleChoiceInitial());
  final repo = KanjiRepository.instance;
  final AudioPlayer audioPlayer = AudioPlayer();

  Choice createChoiceKanjiToMean(List<Kanji> list, Kanji kanji, int index) {
    var listNotHaveAnswer =
        list.where((element) => element.id != kanji.id).toList();
    listNotHaveAnswer.shuffle();
    var temp = listNotHaveAnswer.take(3).toList();
    temp.add(kanji);
    temp.shuffle();
    return Choice(
        id: index.toString(),
        a: temp[0].mean,
        b: temp[1].mean,
        c: temp[2].mean,
        d: temp[3].mean,
        title:  kanji.kanji,
        question: kanji.kanji,
        answer: kanji.mean);
  }

  Choice createChoiceMeanToKanji(List<Kanji> list, Kanji kanji, int index) {
    var listNotHaveAnswer =
        list.where((element) => element.id != kanji.id).toList();
    listNotHaveAnswer.shuffle();
    var temp = listNotHaveAnswer.take(3).toList();
    temp.add(kanji);
    temp.shuffle();
    return Choice(
        id: index.toString(),
        a: temp[0].kanji,
        b: temp[1].kanji,
        c: temp[2].kanji,
        d: temp[3].kanji,
        title:  kanji.kanji,
        question: kanji.mean,
        answer: kanji.kanji);
  }

  Choice createChoiceVocabularyToMean(List<Kanji> list, Kanji kanji, int index) {
    var listNotHaveAnswer =
    list.where((element) => element.id != kanji.id).toList();
    listNotHaveAnswer.shuffle();
    var temp = listNotHaveAnswer.take(3).toList();
    var listVocs = <VocabularyKanji>[];
    for(var i in temp) {
      listVocs.addAll(i.vocabularies);
    }
    listVocs.shuffle();
    var listAns = listVocs.take(3).toList();
    var indexAnswer = Random().nextInt(kanji.vocabularies.length);
    listAns.add(kanji.vocabularies[indexAnswer]);
    listAns.shuffle();
    return Choice(
        id: index.toString(),
        a: listAns[0].mean,
        b: listAns[1].mean,
        c: listAns[2].mean,
        d: listAns[3].mean,
        title:  kanji.kanji,
        question:kanji.vocabularies[indexAnswer].word,
        answer: kanji.vocabularies[indexAnswer].mean);
  }

  Choice createChoiceMeanToVocabulary(List<Kanji> list, Kanji kanji, int index) {
    var listNotHaveAnswer =
    list.where((element) => element.id != kanji.id).toList();
    listNotHaveAnswer.shuffle();
    var temp = listNotHaveAnswer.take(3).toList();
    var listVocs = <VocabularyKanji>[];
    for(var i in temp) {
      listVocs.addAll(i.vocabularies);
    }
    listVocs.shuffle();
    var listAns = listVocs.take(3).toList();
    var indexAnswer = Random().nextInt(kanji.vocabularies.length);
    listAns.add(kanji.vocabularies[indexAnswer]);
    listAns.shuffle();
    return Choice(
        id: index.toString(),
        a: listAns[0].word,
        b: listAns[1].word,
        c: listAns[2].word,
        d: listAns[3].word,
        title:  kanji.kanji,
        question:kanji.vocabularies[indexAnswer].mean,
        answer: kanji.vocabularies[indexAnswer].word);
  }
  Choice createChoiceKanjiToKun(List<Kanji> list, Kanji kanji, int index) {
    var listNotHaveAnswer =
    list.where((element) => element.id != kanji.id).toList();
    listNotHaveAnswer.shuffle();
    var temp = listNotHaveAnswer.take(3).toList();
    var listKun = <String>[];
    for(var i in temp) {
      var spl = i.kunyomi.split('/');
      var random = Random().nextInt(spl.length);
      listKun.add(spl[random]);
    }
    var kunTrueSpl = kanji.kunyomi.split('/');
    var indexAnswer = Random().nextInt(kunTrueSpl.length);
    listKun.add(kunTrueSpl[indexAnswer]);
    listKun.shuffle();
    return Choice(
        id: index.toString(),
        a: listKun[0],
        b: listKun[1],
        c: listKun[2],
        d: listKun[3],
        title:  kanji.kanji,
        question: kanji.kanji,
        answer: kunTrueSpl[indexAnswer]);
  }
  Future<List<Choice>> createListChoices() async {
    var listKanji = await KanjiRepository.instance.getKanjis();
    var listChoices = <Choice>[];
    for (int i = 0; i < 40; i++) {
      int typeValue = Random().nextInt(5);
      int value = Random().nextInt(listKanji.length);
      switch (typeValue) {
        case 0:
          final item = createChoiceKanjiToMean(listKanji, listKanji[value], i);
          listChoices.add(item);
        case 1:
          final item = createChoiceMeanToKanji(listKanji, listKanji[value], i);
          listChoices.add(item);
        case 2 :
          final item = createChoiceVocabularyToMean(listKanji, listKanji[value], i);
          listChoices.add(item);
        case 3 :
          final item = createChoiceMeanToVocabulary(listKanji, listKanji[value], i);
          listChoices.add(item);
        case 4 :
          final item = createChoiceKanjiToKun(listKanji, listKanji[value], i);
          listChoices.add(item);
      }
    }
    return listChoices;
  }

  void getData() async {
    var listChoice = await createListChoices();
    emit(KanjiMultipleChoiceLoaded(
        isMuted: false,
        isShowResult: false,
        isClick: false,
        indexCurrent: 0,
        listChoices: listChoice,
        listAnswersStatus: const ['none', 'none', 'none', 'none'],
        historyAnswers: const []));
  }

  void onDoAgain() async {
    if (state is KanjiMultipleChoiceLoaded) {
      final stateNow = state as KanjiMultipleChoiceLoaded;
      var listChoices = await createListChoices();
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
      if (stateNow.isMuted) {
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
          isClick: false));
    }
  }
}
