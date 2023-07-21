import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/conversation.dart';
import '../../repositories/conversation_repository.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
part 'conversation_event.dart';

part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationInitial()) {
    final consRepo = ConversationRepository.instance;
    final AudioPlayer audioPlayer = AudioPlayer();
    on<GetAllConversations>((event, emit) async {
      try {
        var list = await consRepo.getAllLessons(event.idLesson);
        final isBlur = await consRepo.getBlur();
        final isTranslate = await consRepo.getTranslate();
        final isPhonetic = await consRepo.getPhonetic();
        emit(ConversationLoaded(
          listConversations: list,
          timePosition: 0,
          audioPlayer: audioPlayer,
          isPlaying: true,
          isBlur: isBlur,
          isSpeed: false,
          isTranslate: isTranslate,
          isPhonetic: isPhonetic,
          itemPositions: const <ItemPosition>[],
        ));
      } catch (e) {
        print(e);
      }
    });
    bool checkHighLight(double time, int start, int end) {
      if(time > start * 100  && time < end * 100) {
        return true;
      }
      else {
        return false;
      }
    }
    bool checkIndexInItemPositions(int index , List<ItemPosition> list){
      for (var element in list) {
        if(element.index == index) {
          return true;
        }
      }
      return false;
    }
    on<UpdateTimeHighLight>((event, emit) async {
      if (state is ConversationLoaded) {
        try {
          var index  = (state as ConversationLoaded).listConversations.indexWhere((e) => checkHighLight(event.timeHighLight, e.start, e.end));
          if(index != -1) {
            final isHighLight = (state as ConversationLoaded).listConversations[index].isHighLight;
            var list = (state as ConversationLoaded).listConversations.map((e) {
              if (checkHighLight(event.timeHighLight, e.start, e.end)) {
                return e.copyWith(isHighLight: true);
              } else {
                return e.copyWith(isHighLight: false);
              }
            }).toList();
            emit(ConversationLoaded(
              listConversations: list,
              timePosition: event.timeHighLight,
              audioPlayer: (state as ConversationLoaded).audioPlayer,
              isPlaying: (state as ConversationLoaded).isPlaying,
              isBlur: (state as ConversationLoaded).isBlur,
              isSpeed: (state as ConversationLoaded).isSpeed,
              isTranslate: (state as ConversationLoaded).isTranslate,
              isPhonetic: (state as ConversationLoaded).isPhonetic,
              itemPositions: (state as ConversationLoaded).itemPositions,
            ));
            if(!isHighLight && !checkIndexInItemPositions(index, (state as ConversationLoaded).itemPositions) ) {

              event.scrollController.scrollTo(
                index: index,
                alignment: 0.6,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            }

          }
          else {
            var list = (state as ConversationLoaded).listConversations.map((e) {
              return e.copyWith(isHighLight: false);
            }).toList();
            emit(ConversationLoaded(
              listConversations:  list,
              timePosition: event.timeHighLight,
              audioPlayer: (state as ConversationLoaded).audioPlayer,
              isPlaying: (state as ConversationLoaded).isPlaying,
              isBlur: (state as ConversationLoaded).isBlur,
              isSpeed: (state as ConversationLoaded).isSpeed,
              isTranslate: (state as ConversationLoaded).isTranslate,
              isPhonetic: (state as ConversationLoaded).isPhonetic,
              itemPositions: (state as ConversationLoaded).itemPositions,
            ));
            if (event.timeHighLight == 0 ) {

              event.scrollController.scrollTo(
                index: 0, // Replace `itemHeight` with the height of each conversation item
                duration: const Duration(milliseconds: 500),
                alignment: 0.1,
                curve: Curves.easeOut,
              );
            }
          }

        } catch (e) {
          print(e);
        }
      }
    });

    on<ConversationPlay>((event, emit) async {
      if (state is ConversationLoaded) {
        try {
          emit(ConversationLoaded(
            listConversations: (state as ConversationLoaded).listConversations,
            timePosition: (state as ConversationLoaded).timePosition,
            audioPlayer: (state as ConversationLoaded).audioPlayer,
            isPlaying: event.isPlaying,
            isBlur: (state as ConversationLoaded).isBlur,
            isSpeed: (state as ConversationLoaded).isSpeed,
            isTranslate: (state as ConversationLoaded).isTranslate,
            isPhonetic: (state as ConversationLoaded).isPhonetic,
            itemPositions: (state as ConversationLoaded).itemPositions,
          ));
          if (event.isPlaying) {
            await (state as ConversationLoaded).audioPlayer.play();
          } else {
            await (state as ConversationLoaded).audioPlayer.pause();
          }
        } catch (e) {
          print(e);
        }
      }
    });


    on<UpdateActionMiddle>((event, emit) async {
      if (state is ConversationLoaded) {
        try {
          if(event.index == 1) {
            await consRepo.setBlur(!(state as ConversationLoaded).isBlur);
          }
          else if(event.index == 2) {
            await consRepo.setTranslate(!(state as ConversationLoaded).isTranslate);
          }
          else if(event.index == 3) {
            await consRepo.setPhonetic(!(state as ConversationLoaded).isPhonetic);
          }
          emit(ConversationLoaded(
            listConversations: (state as ConversationLoaded).listConversations,
            timePosition: (state as ConversationLoaded).timePosition,
            audioPlayer: (state as ConversationLoaded).audioPlayer,
            isPlaying: (state as ConversationLoaded).isPlaying,
            isBlur: event.index == 1 ? !(state as ConversationLoaded).isBlur : (state as ConversationLoaded).isBlur,
            isSpeed: event.index == 4 ? !(state as ConversationLoaded).isSpeed : (state as ConversationLoaded).isSpeed,
            isTranslate: event.index == 2 ? !(state as ConversationLoaded).isTranslate: (state as ConversationLoaded).isTranslate,
            isPhonetic:event.index == 3 ?  !(state as ConversationLoaded).isPhonetic : (state as ConversationLoaded).isPhonetic,
            itemPositions: (state as ConversationLoaded).itemPositions,
          ));
        } catch (e) {
          print(e);
        }
      }
    });
    on<UpdateItemPositions>((event, emit) async {

      if (state is ConversationLoaded) {
        try{
          emit(ConversationLoaded(
            listConversations: (state as ConversationLoaded).listConversations,
            timePosition: (state as ConversationLoaded).timePosition,
            audioPlayer: (state as ConversationLoaded).audioPlayer,
            isPlaying: (state as ConversationLoaded).isPlaying,
            isBlur: (state as ConversationLoaded).isBlur,
            isSpeed: (state as ConversationLoaded).isSpeed,
            isTranslate:(state as ConversationLoaded).isTranslate,
            isPhonetic:(state as ConversationLoaded).isPhonetic,
            itemPositions: event.items,
          ));
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
