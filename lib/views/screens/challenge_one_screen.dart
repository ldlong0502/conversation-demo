import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../models/kanji.dart';
import '../../repositories/kanji_repository.dart';

class ChallengeOneScreen extends StatefulWidget {
  const ChallengeOneScreen({Key? key, required this.listKanjis})
      : super(key: key);
  final List<Kanji> listKanjis;

  @override
  State<ChallengeOneScreen> createState() => _ChallengeOneScreenState();
}

class _ChallengeOneScreenState extends State<ChallengeOneScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> listDataAnswer = [];
  List<bool> listHeart = [true, true, true];
  List<Kanji> listQuestion = <Kanji>[];
  bool _isMuted = false;
  int indexCurrent = 0;
  double _start = 5;
  int heart = 3;
  late Timer _timer;
  bool _isShowingDialog = false;
  bool _isClick = false;
  var itemAlert = {
    'title': 'Thất bại',
    'content': 'Bạn đã không thể vượt qua thử thách này. Cố gắng lần tiếp theo nha!',
    'icon': 'assets/images/ic_failed.png'
  };
  void startTimer() {
    const halfSec = Duration(milliseconds: 500);
    _timer = Timer.periodic(
      halfSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            checkAnswer(-1);
          });
        } else {
          setState(() {
            _start = _start - 0.5;
          });
        }
      },
    );
  }

   _loadData() async {
    final limit =
        16 - widget.listKanjis.length > 0 ? 16 - widget.listKanjis.length : 0;
    var listNotBaseOnLesson =
        await KanjiRepository.instance.getKanjisNotBaseOnLesson(limit);
    listQuestion = List.of(widget.listKanjis);
    var temp = List.of(widget.listKanjis);
    temp.addAll(listNotBaseOnLesson);
    listDataAnswer = temp.map((e) {
      return {'item': e, 'status': 'none'};
    }).toList();
    listQuestion.shuffle();
    listDataAnswer.shuffle();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).size.height - kToolbarHeight;
    return listDataAnswer.isEmpty
        ? const Scaffold(
            body: Center(
              child: SizedBox(
                  child: SpinKitCircle(
                color: secondaryColor,
                size: 50.0,
                duration: Duration(seconds: 1),
              )),
            ),
          )
        : Scaffold(
            backgroundColor: primaryColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: headerTitle(),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: _buildHeader(),
                    ),
                    Container(
                      height: height * 0.7,
                      width: double.infinity,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: kanjiColor2,
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: [
                          Expanded(
                              child: Center(
                            child: Text(
                              listQuestion[indexCurrent].vi,
                              textAlign: TextAlign.center,
                              style: kTitle.copyWith(
                                color: green,
                                fontSize: 30,
                              ),
                            ),
                          )),
                          Expanded(flex: 4, child: _buildGridAnswer())
                        ],
                      ),
                    ),
                    Text(
                      '${indexCurrent + 1}/${listQuestion.length}',
                      style: kTitle.copyWith(color: green),
                    )
                  ],
                ),
                if (_isShowingDialog)
                  GestureDetector(
                    onTap: () {},
                    child: Opacity(
                      opacity: 0.8, // Độ mờ của lớp
                      child: Container(
                        color: primaryColor, // Màu của lớp mờ
                      ),
                    ),
                  ),

                AnimatedPositioned(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  top:
                      _isShowingDialog ? size.height * 0.2 : -size.height * 0.5,
                  left: size.width * 0.1,
                  right: size.width * 0.1,
                  child: Stack(
                    children: [
                      Container(
                          height: height * 0.5,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0.0, 3.0),
                                  spreadRadius: 2,
                                  blurRadius: 4.0,
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(itemAlert['title']!, style: kTitle.copyWith(
                                color: red,
                                fontSize: 30
                              ),),
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(itemAlert['content']!,
                                  textAlign: TextAlign.center,
                                  style: kTitle.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14
                                ),),
                              )
                            ],
                          )),
                      Positioned(
                          height: 30,
                          width: 50,
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30)

                              ),
                              border: Border.all(color: red),
                              color: primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0.0, 3.0),
                                    spreadRadius: 2,
                                    blurRadius: 4.0,
                                  ),
                                ]
                            ),
                              child: const Center(child: Icon(Icons.clear_rounded, color: red, size: 15,),),
                      ),
                          )),
                      Positioned(
                          bottom: 30,
                          height: 30,
                          left: (size.width * 0.8 - 120 ) /2,
                          width: 120,
                          child: GestureDetector(
                            onTap:   (){
    _onDoAgain();
    },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(30),
                                  color: red,
                                  boxShadow: [
                                    BoxShadow(
                                      color: red.withOpacity(0.4),
                                      offset: const Offset(0.0, 3.0),
                                      spreadRadius: 4,
                                      blurRadius: 4.0,
                                    ),
                                  ]
                              ),
                              child:  Center(child: Text('Làm lại', style: kTitle.copyWith(color: primaryColor),)),
                            ),
                          ))
                    ],
                  ),
                ),
                // if (_isShowingDialog)
                // Positioned(
                //   top: size.height * 0.2 - 50,
                //   left: size.width * 0.5  - 50,
                //   child: TweenAnimationBuilder(
                //     tween: Tween<double>(begin: 0, end: 1),
                //     duration: Duration(milliseconds: 1000),
                //     curve: Curves.elasticOut,
                //     builder: (context, double value, child) {
                //       final offset = Offset(0, value * (size.height * 0.02));
                //       return Transform.translate(
                //         offset: offset,
                //         child: CircleAvatar(
                //               backgroundColor: Colors.transparent,
                //               radius: 50,
                //               child: Image.asset(
                //                   itemAlert['icon']!
                //               ),
                //             )
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          );
  }

  headerTitle() {
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
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
                      'Thử thách 1',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ))),
                Expanded(
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isMuted = !_isMuted;
                              audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
                            });
                          },
                          icon: Icon(
                            _isMuted
                                ? Icons.volume_mute_rounded
                                : Icons.volume_down_rounded,
                            color: primaryColor,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]));
  }

  _buildGridAnswer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            mainAxisSpacing: 8 // Số cột
            ),
        itemCount: 16,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (_isClick) return;
              setState(() {
                _isClick = true;
              });
              _timer.cancel();
              checkAnswer(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: getColor(index),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: getBorderColor(index), width: getBorder(index)),
                boxShadow: [
                  listDataAnswer[index]['status'] != 'none'
                      ? BoxShadow()
                      : BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0.0, 8.0),
                          spreadRadius: 2,
                          blurRadius: 4.0,
                        ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    listDataAnswer[index]['item'].kanji,
                    style: kTitle.copyWith(
                        color: getTextColor(index), fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getColor(int index) {
    if (listDataAnswer[index]['status'] == 'none') {
      return primaryColor;
    } else if (listDataAnswer[index]['status'] == 'true') {
      return green;
    } else if (listDataAnswer[index]['status'] == 'false') {
      return red;
    } else {
      return old;
    }
  }

  double getBorder(int index) {
    if (listDataAnswer[index]['status'] == 'none') {
      return 1;
    } else {
      return 0;
    }
  }

  void playAudio(bool answer) {
    if (answer) {
      audioPlayer.setAsset('assets/audios/right.mp3').then((_) {
        audioPlayer.play();
      });
    } else {
      audioPlayer.setAsset('assets/audios/wrong.mp3').then((_) {
        audioPlayer.play();
      });
    }
  }

  void checkAnswer(int index) {
    if (index == -1) {
      playAudio(false);
      heartDown();
      setState(() {
        final trueIndex = listDataAnswer.indexWhere(
            (e) => e['item'].kanji == listQuestion[indexCurrent].kanji);
        listDataAnswer[trueIndex]['status'] = 'true';
      });
    } else {
      if (listDataAnswer[index]['status'] == 'old') return;
      if (listQuestion[indexCurrent].kanji ==
          listDataAnswer[index]['item'].kanji) {
        playAudio(true);
        setState(() {
          listDataAnswer[index]['status'] = 'true';
        });
      } else {
        playAudio(false);
        heartDown();
        setState(() {
          listDataAnswer[index]['status'] = 'false';
          final trueIndex = listDataAnswer.indexWhere(
              (e) => e['item'].kanji == listQuestion[indexCurrent].kanji);
          listDataAnswer[trueIndex]['status'] = 'true';
        });
      }
    }
    final item = listDataAnswer
        .firstWhere((e) => e['item'].kanji == listQuestion[indexCurrent].kanji);

    //check if heart = 0;
    if (heart == 0) {
      setState(() {
        _isShowingDialog = true;
        return;
      });
    } else {
      Future.delayed(const Duration(seconds: 1))
          .then((value) => nextQuestion(item['item']));
    }
  }

  getTextColor(int index) {
    if (listDataAnswer[index]['status'] == 'none') {
      return green;
    } else if (listDataAnswer[index]['status'] == 'true') {
      return primaryColor;
    } else if (listDataAnswer[index]['status'] == 'false') {
      return primaryColor;
    } else {
      return green;
    }
  }

  FutureOr nextQuestion(Kanji oldKanji) {
    if(indexCurrent + 1 == listQuestion.length){
      setState(() {
        _isShowingDialog = true;
        itemAlert = {
          'title': 'Chúc mừng',
          'content': 'Bạn thật xuất sắc khi đã hoàn thành toàn bộ thử thách!',
          'icon': 'assets/images/ic_success.png'
        };
      });
    }
    else{
      setState(() {
        indexCurrent++;
        _isClick = false;
        listDataAnswer = listDataAnswer.map((e) {
          if (e['status'] == 'old') {
            return e;
          } else if (e['item'].id == oldKanji.id) {
            return {
              'item': e['item'],
              'status': 'old',
            };
          } else {
            return {
              'item': e['item'],
              'status': 'none',
            };
          }
        }).toList();

        _start = 5;
        startTimer();
      });
    }

  }

  getBorderColor(int index) {
    if (listDataAnswer[index]['status'] == 'none') {
      return green;
    } else if (listDataAnswer[index]['status'] == 'true') {
      return green;
    } else if (listDataAnswer[index]['status'] == 'false') {
      return red;
    } else {
      return old;
    }
  }

  _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: LinearPercentIndicator(
              animation: true,
              animateFromLastPercent: true,
              isRTL: true,
              lineHeight: 10.0,
              animationDuration: 0,
              percent: _start / 5,
              barRadius: const Radius.circular(20.0),
              progressColor: green,
            ),
          ),
          Row(
              children: listHeart
                  .map((e) => Icon(
                        Icons.favorite,
                        color: e ? red : old,
                      ))
                  .toList())
        ],
      ),
    );
  }

  void heartDown() {
    setState(() {
      heart--;
      listHeart[heart] = false;
    });
  }

  _onDoAgain() async {
    await _loadData();
    indexCurrent = 0;
    _start = 5;
    heart = 3;
    _isShowingDialog = false;
    _isClick = false;
    listHeart = [true, true, true];
    itemAlert = {
      'title': 'Thất bại',
      'content': 'Bạn đã không thể vượt qua thử thách này. Cố gắng lần tiếp theo nha!',
      'icon': 'assets/images/ic_failed.png'
    };
    startTimer();
    setState(() {
    });
  }
}
