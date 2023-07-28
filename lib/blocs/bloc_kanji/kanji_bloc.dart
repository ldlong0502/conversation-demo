import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/models/kanji.dart';
import 'package:untitled/models/look_and_learn.dart';
import 'package:untitled/repositories/api_helper.dart';
import 'package:untitled/repositories/kanji_repository.dart';

import '../../models/vocabulary.dart';
import '../../utils/split_text.dart';

part 'kanji_event.dart';

part 'kanji_state.dart';

class KanjiBloc extends Bloc<KanjiEvent, KanjiState> {
  final kanjiRepo = KanjiRepository.instance;

  KanjiBloc() : super(KanjiInitial()) {
    on<GetAllKanjis>((event, emit) async {
      var list = await kanjiRepo.getAllKanjis();
      list.sort((a, b) => (int.parse(a.order1).compareTo(int.parse(b.order1))));
      var newList = <Kanji>[];
      for (var item in list) {
        if (await kanjiRepo.checkKanjiHighLight(item.id)) {
          newList.add(item.copyWith(isHighLight: true));
        } else {
          newList.add(item);
        }
      }
      emit(KanjiLoaded(
          listKanjis: newList,
          isHideActionPracticeWriting: false,
          listVocs: const <Vocabulary>[],
          kanjiCurrent: newList[0]));
    });

    on<UpdateKanjiCurrent>((event, emit) async {
      if (state is KanjiLoaded) {
        var stateNow = (state as KanjiLoaded);
        emit(KanjiLoaded(
            listKanjis: stateNow.listKanjis,
            isHideActionPracticeWriting: stateNow.isHideActionPracticeWriting,
            listVocs: const <Vocabulary>[],
            kanjiCurrent: event.kanji));
      }
    });
    on<UpdateListVocabularies>((event, emit) async {
      if (state is KanjiLoaded) {
        var stateNow = (state as KanjiLoaded);
        final listIntVoc =
            SplitText().extractVocabularies(event.kanji.vocabularies);
        final listVocs =
            await KanjiRepository.instance.getVocabularies(listIntVoc);
        final look_and_learn = await kanjiRepo.getLookAndLearnById(stateNow.kanjiCurrent.order1);

        final pathImage = await ApiHelper.instance.getPathFileImageUsageKanji(stateNow.kanjiCurrent.order1, event.context);

        var list = stateNow.listKanjis.map((e) {
          if(e.id ==stateNow.kanjiCurrent.id) {
            return e.copyWith(lookAndLearn: look_and_learn.copyWith(imageUrl: pathImage));
          } else {
            return e;
          }
        }).toList();

        final itemNow = list.firstWhere((element) => element.id == stateNow.kanjiCurrent.id);
        emit(KanjiLoaded(
            listKanjis: list,
            isHideActionPracticeWriting: stateNow.isHideActionPracticeWriting,
            listVocs: listVocs,
            kanjiCurrent: itemNow));
      }
    });

    on<HighLightCurrentKanji>((event, emit) async {
      if (state is KanjiLoaded) {
        var stateNow = (state as KanjiLoaded);
        if (stateNow.kanjiCurrent.isHighLight) {
          await kanjiRepo.removeKanjiHighLight(stateNow.kanjiCurrent.id);
        } else {
          await kanjiRepo.insertKanjiHighLight(stateNow.kanjiCurrent.id);
        }
        final item = stateNow.kanjiCurrent
            .copyWith(isHighLight: !stateNow.kanjiCurrent.isHighLight);

        final index =
            stateNow.listKanjis.indexWhere((element) => element.id == item.id);
        stateNow.listKanjis[index] = item;
        emit(KanjiLoaded(
            listKanjis: stateNow.listKanjis,
            isHideActionPracticeWriting: stateNow.isHideActionPracticeWriting,
            listVocs: stateNow.listVocs,
            kanjiCurrent: item));
      }
    });

    on<ChangeFirstItem>((event, emit) async {
      if (state is KanjiLoaded) {
        var stateNow = (state as KanjiLoaded);
        emit(KanjiLoaded(
            listKanjis: stateNow.listKanjis,
            isHideActionPracticeWriting: false,
            listVocs: const <Vocabulary>[],
            kanjiCurrent: stateNow.listKanjis[0]));
      }
    });

    on<HideActionClick>((event, emit) async {
      if (state is KanjiLoaded) {
        var stateNow = (state as KanjiLoaded);
        emit(KanjiLoaded(
            listKanjis: stateNow.listKanjis,
            isHideActionPracticeWriting: !stateNow.isHideActionPracticeWriting,
            listVocs: stateNow.listVocs,
            kanjiCurrent: stateNow.kanjiCurrent));
      }
    });

    on<UpdateUsageDetail>((event, emit) async {
      if (state is KanjiLoaded) {
        var stateNow = (state as KanjiLoaded);

        final look_and_learn = await kanjiRepo.getLookAndLearnById(stateNow.kanjiCurrent.order1);

        final pathImage = await ApiHelper.instance.getPathFileImageUsageKanji(stateNow.kanjiCurrent.order1, event.context);

        var list = stateNow.listKanjis.map((e) {
          if(e.id ==stateNow.kanjiCurrent.id) {
            return e.copyWith(lookAndLearn: look_and_learn.copyWith(imageUrl: pathImage));
          } else {
            return e;
          }
        }).toList();

        final itemNow = list.firstWhere((element) => element.id == stateNow.kanjiCurrent.id);
        emit(KanjiLoaded(
            listKanjis: list,
            isHideActionPracticeWriting: stateNow.isHideActionPracticeWriting,
            listVocs: stateNow.listVocs,
            kanjiCurrent: itemNow));
      }
    });
  }
}
