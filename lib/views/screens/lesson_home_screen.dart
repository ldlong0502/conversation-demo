import 'package:flutter/material.dart';
import 'package:untitled/views/screens/grammar_sreen.dart';
import 'package:untitled/views/screens/kanji_screen.dart';
import 'package:untitled/views/widgets/lesson_grid_item_widget.dart';

import '../../constants/constants.dart';
import 'list_screen.dart';

class LessonHomeScreen extends StatelessWidget {
  const LessonHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: headerTitle(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            buildGridView(context),
            const SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }

  headerTitle(context) {

    return Container(
        height: 100,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: secondaryColor,
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
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: primaryColor,
                      )),
                ),
              ),
              const Expanded(
                  flex: 3,
                  child: Center(
                      child: Text(
                    'Bài học số 1',
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ))),
              Expanded(child: Container())
            ],
          ),
        ]));
  }

  buildGridView(context) {
    var listItems = [
      {
        'title': 'Luyện nghe',
        'iconUrl': 'assets/images/ic_listening.png',
        'onPress': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const ListScreen()));
        }
      },
      {
        'title': 'Chữ Hán',
        'iconUrl': 'assets/images/ic_kanji.png',
        'onPress': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const KanjiScreen()));
        }
      },
      {
        'title': 'Từ vựng',
        'iconUrl': 'assets/images/ic_vocabulary.png',
        'onPress': () {}
      },
      {
        'title': 'Ngữ pháp',
        'iconUrl': 'assets/images/ic_grammar.png',
        'onPress': () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const GrammarScreen()));
        }
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 30),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          childAspectRatio: 0.9,
          mainAxisSpacing: 10// Số cột
        ),
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return LessonGridItemWidget(
              title: listItems[index]['title'] as String,
              iconUrl: listItems[index]['iconUrl'] as String,
              onPress: listItems[index]['onPress']as Function());
        },
      ),
    );
  }
}
