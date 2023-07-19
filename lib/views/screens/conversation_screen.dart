import 'package:flutter/material.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/views/widgets/circle_action.dart';
import 'package:untitled/views/widgets/conversation_item_left.dart';
import 'package:untitled/views/widgets/conversation_item_right.dart';

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
  double _sliderValue = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<ConversationBloc>()
        .add( GetAllConversations(idLesson:  widget.lesson.id));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        if(state is ConversationLoaded){
          return Padding(
            padding: const EdgeInsets.only(top: 200, right: 10, left: 10),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.listConversations.length,
                itemBuilder: (context, idx) {
                  if( state.listConversations[idx].character == 'A') {
                    return ConversationItemLeft(cons: state.listConversations[idx],);
                  }
                  else {
                    return ConversationItemRight(cons: state.listConversations[idx],);
                  }
                }),
          );
        }else {
          return Container();
        }
      }
    );
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
      child: Column(
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
          sliderPlay(),
        ],
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAction(),
        CircleAction(),
        CircleAction(),
        CircleAction(),
      ],
    );
  }

  sliderPlay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 25,
          width: 25,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: secondaryColor),
          alignment: Alignment.center,
          child: const Icon(Icons.pause, color: Colors.white, size: 20),
        ),
        Flexible(
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight: 0.5,
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
            ),
            child: Slider(
              value: _sliderValue,
              thumbColor: secondaryColor,
              activeColor: secondaryColor,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
