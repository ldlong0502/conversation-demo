import 'package:flutter/material.dart';
import 'package:untitled/views/screens/youtube_video_screen.dart';
import 'package:untitled/views/widgets/dialogs.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../constants/constants.dart';
import '../../models/grammar.dart';

class GrammarDetailsScreen extends StatelessWidget {
  const GrammarDetailsScreen({Key? key, required this.grammar})
      : super(key: key);
  final Grammar grammar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: headerTitle(context),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                bodyDetailGrammar(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 50,
              right: 0,
              child: GestureDetector(
                onTap: (){
                  if(grammar.youtubeLink == '') {
                    Dialogs().showSorryDialog(context);
                  }
                  else{
                    String? videoId = YoutubePlayer.convertUrlToId(grammar.youtubeLink);
                    Dialogs().showYoutubePopup(context, videoId!);
                  }
                },
                child: Container(
                  height: 45,
                  width: 150,
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                  ),
                  child: Center(
                    child: Text('Bài giảng'.toUpperCase() , style: kTitle.copyWith(color: primaryColor),),
                  ),

                ),
              ))
        ],
      ),
    );
  }

  headerTitle(context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: secondaryColor,
                        size: 30,
                      )),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Center(
                      child: Text(
                    grammar.titleVi.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ))),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.star_rounded,
                            color: secondaryColor,
                            size: 30,
                          )),
                    ],
                  ))
            ],
          ),
        ]));
  }

  bodyDetailGrammar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          categoryTitle('Cấu trúc', Icons.account_tree),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              grammar.structuresVi,
              style: kTitle.copyWith(fontSize: 15, color: Colors.black),
            ),
          ),
          categoryTitle('Cách dùng', Icons.lightbulb_outline_rounded),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              grammar.usesVi,
              style: kTitle.copyWith(fontSize: 15, color: Colors.black),
            ),
          ),
          categoryTitle('Chú ý', Icons.highlight_rounded),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              grammar.noteVi,
              style: kTitle.copyWith(fontSize: 15, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  categoryTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: secondaryColor,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: kTitle.copyWith(fontSize: 20),
          )
        ],
      ),
    );
  }
}
