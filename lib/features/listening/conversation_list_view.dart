import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/features/listening/message_left.dart';
import 'package:untitled/features/listening/message_right.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/sentences.dart';
import '../../services/sound_service.dart';

class ConversationListView extends StatefulWidget {
  const ConversationListView({Key? key, required this.listSentences}) : super(key: key);
  final List<Sentences> listSentences;

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView> {
  final soundService = SoundService.instance;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cubitLesson = context.watch<CurrentLessonCubit>();
    return ScrollablePositionedList.builder(
        padding: const EdgeInsets.only(
            top: 20, bottom: 50, left: 10, right: 10),
        itemScrollController: cubitLesson.scrollControllerConversation,
        itemPositionsListener: cubitLesson.itemListenerConversation,
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        itemCount: widget.listSentences.length,
        itemBuilder: (context, idx) {
          if (widget.listSentences[idx].character == 'A') {
            return MessageLeft(cons: widget.listSentences[idx],);
          } else {
            return MessageRight(cons: widget.listSentences[idx]);
          }
        });
  }
}
