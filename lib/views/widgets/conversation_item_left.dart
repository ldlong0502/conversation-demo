import 'package:flutter/material.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/models/conversation.dart';
import 'package:untitled/utils/split_text.dart';

import 'column_text_phonetic.dart';
class ConversationItemLeft extends StatelessWidget {
  const ConversationItemLeft({Key? key, required this.cons}) : super(key: key);
  final Conversation cons;

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              minWidth: MediaQuery.of(context).size.width * 0.35, // Giá trị maxWidth bạn muốn đặt cho Container
            ),
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
            decoration: BoxDecoration(
              color: primaryColor,
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
            child: Column(
              children: [
                rowPhoneticText(),
                Text(cons.vi, style: kSentenceVi.copyWith(color: secondaryColor),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  rowPhoneticText() {
    var list = SplitText().splitJapanese(cons.phonetic);
    return Wrap(
      children: list.map((e) {
        if(!e.contains('|')) {
          return ColumnTextPhonetic(
            color: secondaryColor,
            textFurigana: e,
            textPhonetic: '',
          );
        }
        else{
          return ColumnTextPhonetic(
            color: secondaryColor,
            textFurigana: SplitText().getFront(e),
            textPhonetic: SplitText().getBehind(e),
          );
        }
      }).toList(),
    );
  }
}
