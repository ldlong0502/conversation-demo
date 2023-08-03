import 'package:flutter/material.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:untitled/models/conversation.dart';

import '../../blocs/listening_effect_cubit/listening_effect_cubit.dart';
import '../../blocs/practice_listening_cubit/conversation_player_cubit.dart';
import '../../configs/app_color.dart';
import '../../utils/split_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'column_text_phonetic.dart';
class MessageRight extends StatelessWidget {
  const MessageRight({Key? key, required this.cons}) : super(key: key);
  final Conversation cons;
  @override
  Widget build(BuildContext context) {
    bool isHighLight = context.watch<ConversationPlayerCubit>().checkHighLight(cons);
    final effectCubit =
    context.watch<ListeningEffectCubit>().state as ListeningEffectLoaded;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              minWidth: MediaQuery.of(context).size.width *
                  0.35, // Giá trị maxWidth bạn muốn đặt cho Container
            ),
            padding: const EdgeInsets.only(
                top: 10, left: 20, right: 20, bottom: 5),
            decoration: BoxDecoration(
              color: isHighLight ? AppColor.blue : AppColor.white,
              border: Border.all(
                color: AppColor.blue,
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
              onTap: () async {
                BlocProvider.of<ConversationPlayerCubit>(context).clickMessageItem(cons);
              },
              // child: state.isTranslate ? Column(
              //   children: [
              //     rowPhoneticText(isHighLight),
              //     Text(
              //       widget.cons.vi,
              //       textAlign: TextAlign.center,
              //       style: kSentenceVi.copyWith(
              //           color: !isHighLight ? AppColor.blue : AppColor.white),
              //     ),
              //   ],
              // ) : Column(
              //   children: [
              //     rowPhoneticText(isHighLight),
              //   ],
              // ),
              child: effectCubit.isTranslate
                  ? Column(
                children: [
                  rowPhoneticText(isHighLight , effectCubit),
                  Text(
                    cons.vi,
                    textAlign: TextAlign.center,
                    style: AppStyle.kSubTitle.copyWith(
                        color: !isHighLight
                            ? AppColor.blue
                            : AppColor.white),
                  ),
                ],
              )
                  : Column(
                children: [
                  rowPhoneticText(isHighLight, effectCubit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  rowPhoneticText(bool isHighLight, ListeningEffectLoaded effectCubit) {
    var list = SplitText().splitJapanese(cons.phonetic);
    return Wrap(
        children: list.map((e) {
          if (!e.contains('|')) {
            return ColumnTextPhonetic(
              color: !isHighLight ? AppColor.blue : AppColor.white,
              textFurigana: e,
              textPhonetic: '',
              isBlur: effectCubit.isBlur,
              isPhonetic: effectCubit.isPhonetic,
            );
          } else {
            return ColumnTextPhonetic(
              color: !isHighLight ? AppColor.blue : AppColor.white,
              textFurigana: SplitText().getFront(e),
              textPhonetic: SplitText().getBehind(e),
              isBlur: effectCubit.isBlur,
              isPhonetic: effectCubit.isPhonetic,
            );
          }
        }).toList());
  }
}
