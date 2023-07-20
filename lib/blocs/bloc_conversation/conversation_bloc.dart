import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/conversation.dart';
import '../../repositories/conversation_repository.dart';

part 'conversation_event.dart';

part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationInitial()) {
    final consRepo = ConversationRepository.instance;
    final AudioPlayer audioPlayer = AudioPlayer();
    on<GetAllConversations>((event, emit) async {
      try {
        var list = await consRepo.getAllLessons(event.idLesson);
        emit(ConversationLoaded(
          listConversations: list,
          timePosition: 0,
          audioPlayer: audioPlayer,
          isPlaying: true,
          isBlur: true,
          isSpeed: false,
          isTranslate: true,
          isPhonetic: true,
        ));
      } catch (e) {
        print(e);
      }
    });

    on<UpdateTimeHighLight>((event, emit) async {
      if (state is ConversationLoaded) {
        try {
          emit(ConversationLoaded(
            listConversations: (state as ConversationLoaded).listConversations,
            timePosition: event.timeHighLight,
            audioPlayer: (state as ConversationLoaded).audioPlayer,
            isPlaying: (state as ConversationLoaded).isPlaying,
            isBlur: (state as ConversationLoaded).isBlur,
            isSpeed: (state as ConversationLoaded).isSpeed,
            isTranslate: (state as ConversationLoaded).isTranslate,
            isPhonetic: (state as ConversationLoaded).isPhonetic,
          ));
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

    on<UpdateItemHighLight>((event, emit) async {
      if (state is ConversationLoaded) {
        try {
          var list = (state as ConversationLoaded).listConversations.map((e) {
            if (e.id == event.cons.id) {
              return e.copyWith(isHighLight: event.isHighLight);
            } else {
              return e;
            }
          }).toList();
          emit(ConversationLoaded(
            listConversations: list,
            timePosition: (state as ConversationLoaded).timePosition,
            audioPlayer: (state as ConversationLoaded).audioPlayer,
            isPlaying: (state as ConversationLoaded).isPlaying,
            isBlur: (state as ConversationLoaded).isBlur,
            isSpeed: (state as ConversationLoaded).isSpeed,
            isTranslate: (state as ConversationLoaded).isTranslate,
            isPhonetic: (state as ConversationLoaded).isPhonetic,
          ));
          if (event.isHighLight) {
            Scrollable.ensureVisible(
                GlobalObjectKey(event.cons.id).currentContext!,
                duration: const Duration(milliseconds: 100),
                // duration for scrolling time
                alignment: .5,
                // 0 mean, scroll to the top, 0.5 mean, half
                curve: Curves.easeOut);
          }
        } catch (e) {
          print(e);
        }
      }
    });

    on<ClickItemConversation>((event, emit) async {
      if (state is ConversationLoaded) {
        try {
          emit(ConversationLoaded(
            listConversations: (state as ConversationLoaded).listConversations,
            timePosition: event.start,
            audioPlayer: (state as ConversationLoaded).audioPlayer,
            isPlaying: true,
            isBlur: (state as ConversationLoaded).isBlur,
            isSpeed: (state as ConversationLoaded).isSpeed,
            isTranslate: (state as ConversationLoaded).isTranslate,
            isPhonetic: (state as ConversationLoaded).isPhonetic,
          ));
          audioPlayer.seek(Duration(milliseconds: event.start.toInt() * 100));
          await audioPlayer.play();
        } catch (e) {
          print(e);
        }
      }
    });

    on<UpdateActionMiddle>((event, emit) async {
      if (state is ConversationLoaded) {
        try {
          emit(ConversationLoaded(
            listConversations: (state as ConversationLoaded).listConversations,
            timePosition: (state as ConversationLoaded).timePosition,
            audioPlayer: (state as ConversationLoaded).audioPlayer,
            isPlaying: (state as ConversationLoaded).isPlaying,
            isBlur: event.index == 1 ? !(state as ConversationLoaded).isBlur : (state as ConversationLoaded).isBlur,
            isSpeed: event.index == 4 ? !(state as ConversationLoaded).isSpeed : (state as ConversationLoaded).isSpeed,
            isTranslate: event.index == 2 ? !(state as ConversationLoaded).isTranslate: (state as ConversationLoaded).isTranslate,
            isPhonetic:event.index == 3 ?  !(state as ConversationLoaded).isPhonetic : (state as ConversationLoaded).isPhonetic,
          ));
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
