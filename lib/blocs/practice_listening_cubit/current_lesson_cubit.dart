import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import '../../repositories/audio_helper.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'listening_list_cubit.dart';

class CurrentLessonCubit extends Cubit<Lesson?> {
  CurrentLessonCubit(this.context) : super(null);
  final BuildContext context;

  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemListener = ItemPositionsListener.create();
  final repo = LessonRepository.instance;

  void load(Lesson lesson) async {
    emit(lesson);
  }



  void playNext() {
    var listLessons = context.read<ListeningListCubit>().state!;
    final index = listLessons.indexWhere((element) => element.id == state!.id);
    final nextIndex = index + 1 == listLessons.length ? 0 : index + 1;
  }
  void playPrevious() {
    var listLessons = context.read<ListeningListCubit>().state!;
    final index = listLessons.indexWhere((element) => element.id == state!.id);
    final previousIndex = index - 1 < 0 ?  listLessons.length -1 : index - 1;
  }

  scrollToIndex() {
    if(state == null) return;
    if(isClosed) return;
    var listLessons = context.read<ListeningListCubit>().state!;
    final index = listLessons.indexWhere((element) => element.id == state!.id);
    if(checkItemVisible(index) == -1) {
      scrollController.scrollTo(index: index, alignment: 0.3, duration: const Duration(milliseconds: 500));
    }
    else if(checkItemVisible(index) == 1) {
      scrollController.scrollTo(index: index, alignment: 0.6, duration: const Duration(milliseconds: 500));
    }
  }

  int checkItemVisible(int index) {
    final indices = itemListener.itemPositions.value.where((e) {
      final isTopVisible = e.itemLeadingEdge > 0;
      final isBottomVisible = e.itemTrailingEdge < 1;
      return isTopVisible && isBottomVisible;
    }).toList().map((e) => e.index).toList();

    if(indices.contains(index)){
      return 0;
    }
    if(index < indices[0]) {
      return -1;
    }
    return 1;
  }
}
