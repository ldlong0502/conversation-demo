

import 'package:flutter/material.dart';
import 'package:untitled/blocs/bloc_conversation/conversation_bloc.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/models/conversation.dart';
import 'package:untitled/utils/split_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'column_text_phonetic.dart';

class ConversationItemLeft extends StatefulWidget {
  const ConversationItemLeft({Key? key, required this.cons, required this.state}) : super(key: key);
  final Conversation cons;
  final ConversationLoaded state;
  @override
  State<ConversationItemLeft> createState() => _ConversationItemLeftState();
}

class _ConversationItemLeftState extends State<ConversationItemLeft> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ConversationBloc, ConversationState>(
            builder: (context, state) {
              if(state is ConversationLoaded) {
                bool isHighLight = checkHighLight(state.timePosition);
                return Container(
                  key: GlobalObjectKey(widget.cons.id),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    minWidth: MediaQuery.of(context).size.width *
                        0.35, // Giá trị maxWidth bạn muốn đặt cho Container
                  ),
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 5),
                  decoration: BoxDecoration(
                    color: isHighLight ? secondaryColor : primaryColor,
                    border: Border.all(
                      color: secondaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0.0, 3.0),
                        spreadRadius: 2,
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: (){
                      context
                          .read<ConversationBloc>()
                          .add(ClickItemConversation(start:  widget.cons.start.toDouble(), end: widget.cons.start.toDouble()));
                      Scrollable.ensureVisible(
                          GlobalObjectKey(widget.cons.id).currentContext!,
                          duration: const Duration(milliseconds: 100),// duration for scrolling time
                          alignment: .5, // 0 mean, scroll to the top, 0.5 mean, half
                          curve: Curves.easeOut);
                    },
                    child:  widget.state.isTranslate ? Column(
                      children: [
                        rowPhoneticText(isHighLight),
                       Text(
                          widget.cons.vi,
                          textAlign: TextAlign.center,
                          style: kSentenceVi.copyWith(
                              color: !isHighLight ? secondaryColor : primaryColor),
                        ),
                      ],
                    ) : Column(
                      children: [
                        rowPhoneticText(isHighLight),
                      ],
                    ),
                  ),
                );
              }
              else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  rowPhoneticText(bool isHighLight) {
    var list = SplitText().splitJapanese(widget.cons.phonetic);
    return Wrap(
      children: list.map((e) {
        if (!e.contains('|')) {
          return ColumnTextPhonetic(
            color: !isHighLight ? secondaryColor : primaryColor,
            textFurigana: e,
            textPhonetic: '',
            isBlur: widget.state.isBlur,
            isPhonetic: widget.state.isPhonetic,
          );
        } else {
          return ColumnTextPhonetic(
            color: !isHighLight ? secondaryColor : primaryColor,
            textFurigana: SplitText().getFront(e),
            textPhonetic: SplitText().getBehind(e),
            isBlur: widget.state.isBlur,
            isPhonetic: widget.state.isPhonetic,
          );
        }
      }).toList(),
    );
  }

  bool checkHighLight(double time) {
    if(time > widget.cons.start * 100  && time < widget.cons.end * 100) {
      if(!widget.cons.isHighLight) {
        context
            .read<ConversationBloc>()
            .add(UpdateItemHighLight(isHighLight: true, cons: widget.cons));
      }
      return true;
    }
    else {
      context
          .read<ConversationBloc>()
          .add(UpdateItemHighLight(isHighLight: false, cons: widget.cons));
      return false;
    }
  }
}
