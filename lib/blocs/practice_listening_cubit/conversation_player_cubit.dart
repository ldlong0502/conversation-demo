import 'package:flutter/cupertino.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_list_cubit.dart';
import 'package:untitled/models/conversation.dart';
import 'package:untitled/models/kanji.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/repositories/lesson_repository.dart';
import '../../repositories/audio_helper.dart';
import '../../repositories/kanji_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
class ConversationPlayerCubit extends Cubit<Lesson?> {
  ConversationPlayerCubit(this.context) : super(null);
  var audioPlayer = AudioPlayer();
  int previousIndex = -1;
  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemListener = ItemPositionsListener.create();
  final repo = LessonRepository.instance;
  final BuildContext context;
  List<Conversation>? listConversations;

  void setListConversations(List<Conversation> list) {
    listConversations = list;
  }
  void load(Lesson lesson) async {
    audioPlayer = AudioPlayer();
    emit(lesson);
    play();
  }
  void play() async {
    emit(state!.copyWith(isLoading: true));
    var duration = const Duration(seconds: 0);
    if(state!.durationMax.inSeconds == 0)
    {
      duration =  await AudioHelper.instance.getDuration(state!.mp3);
    }
    else {
      duration = state!.durationMax;
    }
    emit(state!.copyWith(
        isPlaying: true,
        isLoading: false,
        durationMax: duration
    ));
    final pathAudio =
    await AudioHelper.instance.getPathFileAudio(state!.mp3);
    await Future.delayed(const Duration(seconds: 1));
    await audioPlayer.setFilePath(pathAudio,
        initialPosition: state!.durationCurrent);
    audioPlayer.positionStream.listen((position) {
      if(position.inMilliseconds >= state!.durationMax.inMilliseconds) {
        playCompleted();
      }
      emit(state!.copyWith(durationCurrent: position));
      scrollToWidget();
    });
    await audioPlayer.play();
  }
  void onChanged(double position) async {
    await audioPlayer.seek(Duration(milliseconds: position.toInt()));
  }
  void pause () async {
    emit(state!.copyWith(
      isPlaying: false,

    ));
    await audioPlayer.pause();
  }
  void playCompleted() async {
    await audioPlayer.seek(Duration.zero);
    scrollController.scrollTo(index: 0 ,alignment: 0.1, duration: const Duration(milliseconds: 500) );
    emit(state!.copyWith(durationCurrent: Duration.zero));
    pause();
  }
  void dispose() async {
    audioPlayer.dispose();
  }
  bool checkHighLight(Conversation item) {
    var time = state!.durationCurrent.inMilliseconds.toDouble();
    if(item.end * 100 - 1 > time && time > item.start * 100) {
      return true;
    }
    return false;
  }

  void scrollToWidget() {
    // final listCons = context.read<ConversationListCubit>().state!;
    final listCons = listConversations!;
    final index = listCons.indexWhere((element) => checkHighLight(element));
    if(previousIndex == index || index == -1) return;
    previousIndex = index;
    if(!checkItemVisible(index)) {
      scrollController.scrollTo(
          index: index  + 1 == listCons.length ? listCons.length - 1 : index + 1 ,
          alignment: 0.8,
          duration: const Duration(milliseconds: 500));
    }
  }

  bool checkItemVisible(int index) {
     final indices = itemListener.itemPositions.value.where((e) {
      final isTopVisible = e.itemLeadingEdge >=0;
      final isBottomVisible = e.itemTrailingEdge <=1;
      return isTopVisible && isBottomVisible;
    }).toList().map((e) => e.index).toList();

     if(indices.contains(index)){
       return true;
     }
     return false;
  }

  void clickMessageItem(Conversation cons) async {
    // final listCons = context.read<ConversationListCubit>().state!;
    final listCons = listConversations!;
    final index = listCons.indexWhere((element) => checkHighLight(element));
    if(!checkItemVisible(index)) {
      scrollController.scrollTo(
          index: index  + 1 == listCons.length ? listCons.length - 1 : index + 1 ,
          alignment: 0.8,
          duration: const Duration(milliseconds: 500));
    }
    await audioPlayer.seek(Duration(milliseconds: cons.start * 100));
    emit(state!.copyWith(isPlaying: true));
    await audioPlayer.play();

    // audioPlayer.positionStream.listen((position) {
    //   if(position.inMilliseconds >= cons.end * 100) {
    //     pause();
    //   }
    //   emit(state!.copyWith(durationCurrent: position));
    // });
  }
}