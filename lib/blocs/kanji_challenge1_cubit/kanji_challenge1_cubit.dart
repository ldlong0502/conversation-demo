import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/kanji.dart';
import '../../repositories/kanji_repository.dart';
import 'package:just_audio/just_audio.dart';
part 'kanji_challenge1_state.dart';

class KanjiChallenge1Cubit extends Cubit<KanjiChallenge1State> {
  KanjiChallenge1Cubit() : super(KanjiChallenge1Initial());
  final repo = KanjiRepository.instance;
  final audioPlayer = AudioPlayer();

  void getData(List<Kanji> listKanjis) async {
    final limit = 16 - listKanjis.length > 0 ? 16 - listKanjis.length : 0;
    var listNotBaseOnLesson = await repo.getKanjisNotBaseOnLesson(limit);
    var listQuestion = List.of(listKanjis);
    var temp = List.of(listKanjis);
    temp.addAll(listNotBaseOnLesson);
    var listDataAnswer = temp.map((e) {
      return {'item': e, 'status': 'none'};
    }).toList();
    listQuestion.shuffle();
    listDataAnswer.shuffle();

    emit(KanjiChallenge1Loaded(
        isMuted: false,
        isShowingDialog: false,
        isClick: false,
        indexCurrent: 0,
        listQuestion: listQuestion,
        listHeart: const [true, true, true],
        listDataAnswer: listDataAnswer,
        heart: 3,
        startTime: 5));
  }

  void onDoAgain() async {
    if (state is KanjiChallenge1Loaded) {
      final stateNow = state as KanjiChallenge1Loaded;
      var listQuestion = stateNow.listQuestion;
      final limit = 16 - listQuestion.length > 0 ? 16 - listQuestion.length : 0;
      var listNotBaseOnLesson = await repo.getKanjisNotBaseOnLesson(limit);
      var temp = List.of(listQuestion);
      temp.addAll(listNotBaseOnLesson);
      var listDataAnswer = temp.map((e) {
        return {'item': e, 'status': 'none'};
      }).toList();
      listQuestion.shuffle();
      listDataAnswer.shuffle();
      emit(stateNow.copyWith(
        listQuestion: listQuestion,
        isShowingDialog: false,
        isClick: false,
        listDataAnswer: listDataAnswer,
        indexCurrent: 0,
        listHeart: const [true, true, true],
        heart: 3,
        startTime: 5,
      ));
    }
  }

  void mute() {
    if (state is KanjiChallenge1Loaded) {
      final stateNow = state as KanjiChallenge1Loaded;
      if (stateNow.isMuted) {
        audioPlayer.setVolume(1);
      } else {
        audioPlayer.setVolume(0);
      }
      emit(stateNow.copyWith(isMuted: !stateNow.isMuted));
    }
  }

  onClick(int index) {
    if (state is KanjiChallenge1Loaded) {
      var stateNow = state as KanjiChallenge1Loaded;
      if (stateNow.isClick) return;
      var heart = stateNow.heart;
      var listDataAnswer = List.of(stateNow.listDataAnswer);
      var listHeart = List.of(stateNow.listHeart);
      if (index == -1) {
        playAudio(false);
        heart--;
        listHeart[heart] = false;
        final trueIndex = listDataAnswer.indexWhere((e) =>
            e['item'].kanji ==
            stateNow.listQuestion[stateNow.indexCurrent].kanji);
        listDataAnswer[trueIndex]['status'] = 'true';
      } else {
        if (stateNow.listDataAnswer[index]['status'] == 'old') return;
        if (stateNow.listQuestion[stateNow.indexCurrent].kanji ==
            stateNow.listDataAnswer[index]['item'].kanji) {
          playAudio(true);
          listDataAnswer[index]['status'] = 'true';
        } else {
          playAudio(false);
          heart--;
          listHeart[heart] = false;
          listDataAnswer[index]['status'] = 'false';
          final trueIndex = stateNow.listDataAnswer.indexWhere((e) =>
              e['item'].kanji ==
              stateNow.listQuestion[stateNow.indexCurrent].kanji);
          listDataAnswer[trueIndex]['status'] = 'true';
        }
      }
      final item = stateNow.listDataAnswer.firstWhere((e) =>
          e['item'].kanji ==
          stateNow.listQuestion[stateNow.indexCurrent].kanji);

      if (heart == 0) {
        emit(stateNow.copyWith(
            heart: heart,
            listHeart: listHeart,
            isClick: true,
            isShowingDialog: true));
      } else {
        emit(stateNow.copyWith(
            isClick: true,
            listDataAnswer: listDataAnswer,
            heart: heart,
            listHeart: listHeart));
        Future.delayed(const Duration(seconds: 1))
            .then((value) => nextQuestion(item['item']));
      }
    }
  }

  FutureOr nextQuestion(Kanji oldKanji) {
    if (state is KanjiChallenge1Loaded) {
      var stateNow = state as KanjiChallenge1Loaded;
      if (stateNow.indexCurrent + 1 == stateNow.listQuestion.length) {
        emit(stateNow.copyWith(isShowingDialog: true));
      } else {
        var listDataAnswer = stateNow.listDataAnswer.map((e) {
          if (e['status'] == 'old') {
            return e;
          } else if (e['item'].id == oldKanji.id) {
            return {
              'item': e['item'],
              'status': 'old',
            };
          } else {
            return {
              'item': e['item'],
              'status': 'none',
            };
          }
        }).toList();

        emit(stateNow.copyWith(
            indexCurrent: stateNow.indexCurrent + 1,
            startTime: 5,
            listDataAnswer: listDataAnswer,
            isClick: false));
      }
    }
  }

  void countTimer() {
    if (state is KanjiChallenge1Loaded) {
      var stateNow = state as KanjiChallenge1Loaded;
      if (stateNow.isClick) return;
      if (stateNow.startTime == 0) {
        onClick(-1);
        return;
      }
      emit(stateNow.copyWith(startTime: stateNow.startTime - 0.5));
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

  void heartDown() {}
}
