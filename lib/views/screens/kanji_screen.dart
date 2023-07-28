import 'package:flutter/material.dart';
import 'package:untitled/blocs/bloc_kanji/kanji_bloc.dart';
import 'package:untitled/views/screens/flashcard_screen.dart';
import 'package:untitled/views/screens/grammar_sreen.dart';
import 'package:untitled/views/screens/kanji_detail_screen.dart';
import 'package:untitled/views/screens/practice_write_screen.dart';
import 'package:untitled/views/widgets/lesson_grid_item_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/constants.dart';
import 'list_screen.dart';

class KanjiScreen extends StatefulWidget {
  const KanjiScreen({Key? key}) : super(key: key);

  @override
  State<KanjiScreen> createState() => _KanjiScreenState();
}

class _KanjiScreenState extends State<KanjiScreen> {
  double offset = -130;
  bool isDragUp = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KanjiBloc, KanjiState>(
  builder: (context, state) {
    if(state is KanjiLoaded) {
      return Scaffold(
        backgroundColor: kanjiColor2,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: headerTitle(context),
        ),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10).copyWith(bottom: 0),
              height: double.infinity,
              decoration: const BoxDecoration(
                  color: kanjiColor1,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    buildGridView(context),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                bottom: offset,
                left: 20,
                right: 20,
                child: GestureDetector(
                  onVerticalDragUpdate: (value) {
                    double currentDragY = MediaQuery.of(context).size.height -
                        value.globalPosition.dy -
                        150;
                    setState(() {
                      if (offset < currentDragY) {
                        isDragUp = true;
                      } else {
                        isDragUp = false;
                      }
                      offset = currentDragY;

                      if (offset > 20) {
                        offset = 20;
                      } else if (offset < -130) {
                        offset = -130;
                      }
                    });
                  },
                  onVerticalDragEnd: (value) {
                    setState(() {
                      if (isDragUp) {
                        offset = 20;
                      } else {
                        offset = -130;
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(25))),
                          height: 170,
                          child: buildPracticeAction(state)),
                      Positioned(
                          top: 0,
                          right: 0,
                          height: 25,
                          child: AnimatedOpacity(
                            opacity: (offset == 20) ? 1.0 : 0.0,
                            // Show the container when offset = 20, otherwise hide it
                            duration: Duration(milliseconds: 300),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  offset = -130;
                                });
                              },
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(
                                        color: secondaryColor, width: 1),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25))),
                                child: const Center(
                                  child: Icon(
                                    Icons.clear_rounded,
                                    color: secondaryColor,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            ignoring: (offset > -80),
                            child: AnimatedOpacity(
                              opacity: (offset > -80) ? 0.0 : 1.0,
                              // Show the container when offset = 20, otherwise hide it
                              duration: const Duration(milliseconds: 300),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isDragUp = true;
                                    offset = 20;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          topLeft: Radius.circular(25))),
                                  child: Center(
                                      child: Text(
                                        'Luyện Tập',
                                        style: kTitle.copyWith(
                                            fontSize: 18, color: primaryColor),
                                      )),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ))
          ],
        ),
      );
    }
    else {
      return const CircularProgressIndicator();
    }
  },
);
  }

  headerTitle(context) {
    return Container(
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
                        Navigator.pop(context);
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
                    'Kanji bài 1 ',
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
    return BlocBuilder<KanjiBloc, KanjiState>(
      builder: (context, state) {
        if (state is KanjiLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10 // Số cột
                  ),
              itemCount: state.listKanjis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: ()  {

                    context.read<KanjiBloc>().add(UpdateKanjiCurrent(kanji: state.listKanjis[index]));

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const KanjiDetailScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: state.listKanjis[index].isHighLight ? secondaryColor : primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: secondaryColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(3.0, 8.0),
                          spreadRadius: 2,
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          state.listKanjis[index].kanji,
                          style: kTitle.copyWith(
                              color: !state.listKanjis[index].isHighLight ? secondaryColor : primaryColor,
                              fontSize: 20),
                        ),
                        Text(state.listKanjis[index].vi, style: kTitle.copyWith(
                          color: !state.listKanjis[index].isHighLight ? secondaryColor : primaryColor,
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  buildPracticeAction(KanjiLoaded state) {
    var listItems = [
      {
        'title': 'Chi tiết',
        'iconUrl': 'assets/images/ic_detail.png',
        'onPress': () {
          context.read<KanjiBloc>().add(const ChangeFirstItem());

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const KanjiDetailScreen()));
        }
      },
      {
        'title': 'Luyện Viết',
        'iconUrl': 'assets/images/ic_write.png',
        'onPress': () {
          context.read<KanjiBloc>().add(const ChangeFirstItem());
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PracticeWriteScreen()));
        }
      },
      {
        'title': 'Flashcard',
        'iconUrl': 'assets/images/ic_card.png',
        'onPress': () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  FlashcardScreen(listKanjis: state.listKanjis,)));
        }
      },
      {
        'title': 'Trắc Nghiệm',
        'iconUrl': 'assets/images/ic_choice.png',
        'onPress': () {

        }
      },
      {
        'title': 'Thử thách 1',
        'iconUrl': 'assets/images/ic_challenge.png',
        'onPress': () {

        }
      },
      {
        'title': 'Thử thách 2',
        'iconUrl': 'assets/images/ic_challenge.png',
        'onPress': () {

        }
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
            mainAxisSpacing: 0 // Số cột
            ),
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return RawMaterialButton(
            onPressed: listItems[index]['onPress'] as Function(),
            shape: CircleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(listItems[index]['iconUrl'] as String , height: 40,  fit: BoxFit.cover, ),
                Text(listItems[index]['title'] as String, style: kTitle.copyWith(color: primaryColor , fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }
}
