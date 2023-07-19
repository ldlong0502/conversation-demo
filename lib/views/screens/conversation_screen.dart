import 'package:flutter/material.dart';
import 'package:untitled/models/lesson.dart';

import '../../constants/constants.dart';
class ConversationScreen extends StatelessWidget {
  const ConversationScreen({Key? key, required this.lesson}) : super(key: key);
  final Lesson lesson;
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
    return Padding(
      padding: const EdgeInsets.only(top: 200, right: 10, left: 10),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, idx) {
            return Container(
              height: 55,
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.99),
                  border: Border.all(color: secondaryColor, width: 1),
                  borderRadius: BorderRadius.circular(50)),
              child: ListTile(title: Text('Hi'),),
            );
          }),
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
      child:  Column(

        children: [
         const SizedBox(
            height: 20,
          ),
          headerTitle(context),
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
            flex: 5,
            child: Center(
                child: Text(
                  lesson.vi,
                  style: const TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ))),
        Expanded(child: Container())
      ],
    );
  }
}
