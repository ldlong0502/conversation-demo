import 'package:flutter/material.dart';
import 'package:untitled/blocs/bloc_conversation/conversation_bloc.dart';
import 'package:untitled/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class CircleAction extends StatelessWidget {
  const CircleAction({Key? key, required this.icon, required this.color, required this.index}) : super(key: key);
  final IconData icon;
  final Color color;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ConversationBloc>().add(UpdateActionMiddle(index: index));
      },
      child: Container(
        height: 50,
        width: 50,
        decoration:  BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0.0, 3.0),
              spreadRadius: 2,
              blurRadius: 4.0,
            ),
          ],
        ),
        child:  Icon(icon, color: color,                size: 30,),
      ),
    );
  }
}
