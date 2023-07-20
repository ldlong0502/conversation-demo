import 'package:flutter/material.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/views/widgets/circle_action.dart';
import 'package:untitled/views/widgets/conversation_item_left.dart';
import 'package:untitled/views/widgets/conversation_item_right.dart';
import 'package:untitled/views/widgets/slider_progress.dart';

import '../../blocs/bloc_conversation/conversation_bloc.dart';
import '../../constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key, required this.lesson}) : super(key: key);
  final Lesson lesson;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ConversationBloc>()
        .add(GetAllConversations(idLesson: widget.lesson.id));
    setState(() {
      isLoading = false;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Scaffold(
            backgroundColor: Colors.white.withOpacity(0.99),
            body: Stack(
              children: [
                listConversationsScroll(),
                headerPlayer(context),
              ],
            ),
          );
  }

  listConversationsScroll() {
    return BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
      if (state is ConversationLoaded) {

        return Padding(
          padding: const EdgeInsets.only(top: 200, right: 10, left: 10),
          child: ListView.builder(
            controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: state.listConversations.length,
              itemBuilder: (context, idx) {
                if (state.listConversations[idx].character == 'A') {
                  return ConversationItemLeft(
                    cons: state.listConversations[idx],
                    state: state,
                  );
                } else {
                  return ConversationItemRight(
                    cons: state.listConversations[idx],
                    state: state,
                  );
                }
              }),
        );
      } else {
        return Container();
      }
    });
  }

  headerPlayer(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0.0, 2.0),
            blurRadius: 4.0,
          ),
        ],
        color: primaryColor,
      ),
      child: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is ConversationLoaded) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                headerTitle(context),
                const SizedBox(
                  height: 20,
                ),
                middleAction(),
                const SizedBox(
                  height: 20,
                ),
                SliderProgress(lesson: widget.lesson , state: state, scrollController: _scrollController,),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  headerTitle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: secondaryColor,
                )),
          ),
        ),
        Expanded(
            flex: 3,
            child: Center(
                child: Text(
              widget.lesson.vi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ))),
        Expanded(child: Container())
      ],
    );
  }

  middleAction() {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
       if(state is ConversationLoaded) {
         return  Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             CircleAction(
               icon: Icons.closed_caption_off_rounded,
               color: state.isBlur ? secondaryColor : thirdColor,

               index: 1,
             ),
             CircleAction(
               icon: Icons.translate_outlined,
               color: state.isTranslate ? secondaryColor : thirdColor,
               index: 2
             ),
             CircleAction(
               icon: Icons.spellcheck_sharp,
               color: state.isPhonetic ? secondaryColor : thirdColor,
                 index: 3
             ),
             CircleAction(
               icon: Icons.speed_outlined,
               color: state.isSpeed ? secondaryColor : thirdColor,
                 index: 4
             ),
           ],
         );
       }
       else {
         return Container();
       }
      }
    );
  }
}
