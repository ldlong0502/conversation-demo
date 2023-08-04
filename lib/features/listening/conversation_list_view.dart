import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_player_cubit.dart';
import 'package:untitled/features/listening/message_left.dart';
import 'package:untitled/features/listening/message_right.dart';
import 'package:untitled/models/conversation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/widgets/loading_progress.dart';

import '../../blocs/practice_listening_cubit/conversation_list_cubit.dart';

class ConversationListView extends StatefulWidget {
  const ConversationListView({Key? key}) : super(key: key);

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView> {


  @override
  Widget build(BuildContext context) {
    final consCubit = context.watch<ConversationPlayerCubit>();
    return BlocProvider(
      create: (context) => ConversationListCubit()..getData(consCubit.state!),
      child: BlocBuilder<ConversationListCubit, List<Conversation>?>(
        builder: (context, state) {
          if (state == null) return const LoadingProgress();
          consCubit.setListConversations(state!);
          return Padding(
            padding: const EdgeInsets.only(top: 190,),
            child: ScrollablePositionedList.builder(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 50, left: 10, right: 10),
                itemScrollController: consCubit.scrollController,
                itemPositionsListener: consCubit.itemListener,
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                itemCount: state.length,
                itemBuilder: (context, idx) {
                  if (state[idx].character == 'A') {
                    return MessageLeft(cons: state[idx],);
                  } else {
                    return MessageRight(cons: state[idx]);
                  }
                }),
          );
        },
      ),
    );
  }
}
