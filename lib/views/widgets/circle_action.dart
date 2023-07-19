import 'package:flutter/material.dart';
import 'package:untitled/constants/constants.dart';
class CircleAction extends StatelessWidget {
  const CircleAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Icon(Icons.abc, color: secondaryColor,),
    );
  }
}
