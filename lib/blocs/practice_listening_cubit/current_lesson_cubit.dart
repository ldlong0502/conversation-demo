
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/models/sentences.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import 'package:untitled/services/sound_service.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'listening_list_cubit.dart';

class CurrentLessonCubit extends Cubit<Lesson?> {
  CurrentLessonCubit(this.context) : super(null);
  final BuildContext context;
  ItemScrollController scrollController = ItemScrollController();
  ItemPositionsListener itemListener = ItemPositionsListener.create();
  final ItemScrollController scrollControllerConversation = ItemScrollController();
  final ItemPositionsListener itemListenerConversation = ItemPositionsListener.create();
  final repo = LessonRepository.instance;
  int previousSentencesIndex = -1;
  bool isDetailPage = false;

  setIsDetailPage(bool value){
    isDetailPage = value;
  }
  void load(Lesson lesson) async {
    emit(lesson);
  }

  void playNext() async {
    SoundService.instance.pause();
    var listLessons = context.read<ListeningListCubit>().state!;
    final index = listLessons.indexWhere((element) => element.id == state!.id);
    final nextIndex = index + 1 >= listLessons.length ? 0 : index + 1;
    final path = LessonRepository.instance.getUrlAudioById(listLessons[nextIndex].id.toString());
    emit(listLessons[nextIndex]);
    await SoundService.instance.player!.setFilePath(path);
    SoundService.instance.player!.play();
  }
  void playPrevious() async {
    var listLessons = context.read<ListeningListCubit>().state!;
    final index = listLessons.indexWhere((element) => element.id == state!.id);
    final previousIndex = index - 1 < 0 ?  listLessons.length -1 : index - 1;
    final path = LessonRepository.instance.getUrlAudioById(listLessons[previousIndex].id.toString());
    emit(listLessons[previousIndex]);

    await SoundService.instance.player!.setFilePath(path);
    SoundService.instance.player!.play();
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
    final indices = itemListenerConversation.itemPositions.value.where((e) {
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
  bool checkHighLight(Sentences item) {
    var time = SoundService.instance.player!.position.inMilliseconds.toDouble();
    if (item.end * 100 - 1 > time && time > item.start * 100) {
      return true;
    }
    return false;
  }
  conversationScrollToIndex() {
    if(state == null) return;
    if(!scrollControllerConversation.isAttached) return;
    final index = state!.sentences.indexWhere((element) => checkHighLight(element));
    if (previousSentencesIndex == index || index == -1) return;
    previousSentencesIndex = index;
    if (checkItemVisible(index) == 1) {

      scrollControllerConversation.scrollTo(
          index: index + 1 == state!.sentences.length ? state!.sentences.length - 1 : index + 1,
          alignment: 0.8,
          duration: const Duration(milliseconds: 500));
    }
  }

  highLightConversation(){
    if(state == null) return;
    final index = state!.sentences.indexWhere((element) => checkHighLight(element));
    if(index == -1  ) {
      emit(state!.copyWith(sentences: state!.sentences.map((e) => e.copyWith(isHighLight: false)).toList()));
      return;
    }
    if( state!.sentences[index].isHighLight) {
      return;
    }
    final listSen = state!.sentences.map((e) {
      if(state!.sentences[index].id == e.id) {
        return e.copyWith(isHighLight: true);
      }
      return e.copyWith(isHighLight: false);
    }).toList();
    emit(state!.copyWith(sentences: listSen));
  }

  void clickConversationItem(Sentences cons) {

    if(state == null) return;
     SoundService.instance.seek(Duration(milliseconds: cons.start * 100));
  }
}
