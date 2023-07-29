import 'package:flutter/material.dart';
import 'package:untitled/repositories/kanji_repository.dart';

import '../../constants/constants.dart';
import '../../models/choice.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MultipleChoiceScreen extends StatefulWidget {
  const MultipleChoiceScreen({Key? key}) : super(key: key);

  @override
  State<MultipleChoiceScreen> createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isMuted = false;
  var listChoices = <Choice>[];
  List<String> listAnswersStatus = ['none', 'none', 'none', 'none'];
  List<Map<String, dynamic>> historyAnswers = [];
  int indexCurent = 0;
  bool isClick = false;
  bool isShowResult = false;
  void _loadData() async {
    listChoices = await KanjiRepository.instance.getChoices();
    setState(() {});
  }
  onDoAgain() async {
    listChoices = await KanjiRepository.instance.getChoices();
    setState(() {
        indexCurent = 0;
        isClick = false;
        isShowResult = false;
        historyAnswers = [];
        listAnswersStatus = ['none', 'none', 'none', 'none'];
    });
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return listChoices.isEmpty
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
            body: isShowResult
                ? _buildResult()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: _buildSlider(),
                        ),
                        _buildQuestion()
                      ],
                    ),
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
                      'Trắc nghiệm',
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

  _buildQuestion() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kanjiColor2,
      ),
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                child: AutoSizeText(
                  listChoices[indexCurent].question,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  style: kTitle.copyWith(fontSize: 25, color: Colors.black87),
                ),
              ))),
          Expanded(
              flex: 3,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                _buildAnswer(listChoices[indexCurent].a, 0),
                _buildAnswer(listChoices[indexCurent].b, 1),
                _buildAnswer(listChoices[indexCurent].c, 2),
                _buildAnswer(listChoices[indexCurent].d, 3),
              ]))
        ],
      ),
    );
  }

  int getIndexOfAnswer() {
    if (listChoices[indexCurent].answer == listChoices[indexCurent].a) {
      return 0;
    } else if (listChoices[indexCurent].answer == listChoices[indexCurent].b) {
      return 1;
    } else if (listChoices[indexCurent].answer == listChoices[indexCurent].c) {
      return 2;
    }
    return 3;
  }

  _buildAnswer(String ans, int index) {
    var size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        if (isClick) return;
        setState(() {
          isClick = true;
          listAnswersStatus = listAnswersStatus.map((e) {
            return 'isClick';
          }).toList();
          final indexAnswer = getIndexOfAnswer();
          if (index == indexAnswer) {
            playAudio(true);
            listAnswersStatus[index] = 'true';
            historyAnswers
                .add({'title': listChoices[indexCurent].title, 'answer': true});
          } else {
            playAudio(false);
            listAnswersStatus[index] = 'false';
            listAnswersStatus[indexAnswer] = 'true';
            historyAnswers.add(
                {'title': listChoices[indexCurent].title, 'answer': false});
          }
        });

        await Future.delayed(Duration(seconds: 1))
            .then((value) => nextQuestion());
      },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: 40,
        width: size.width - 40,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: getColor(index),
            boxShadow: [
              listAnswersStatus[index] != 'none'
                  ? BoxShadow()
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0.0, 3.0),
                      spreadRadius: 2,
                      blurRadius: 4.0,
                    ),
            ],
            border:
                Border.all(color: thirdColor, width: getBorderWidth(index))),
        child: Center(
          child: Text(
            ans,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: kTitle.copyWith(fontSize: 18, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  getColor(int index) {
    if (listAnswersStatus[index] == 'none') {
      return primaryColor;
    } else if (listAnswersStatus[index] == 'true') {
      return Colors.green;
    } else if (listAnswersStatus[index] == 'false') {
      return Colors.red;
    } else {
      return kanjiColor2;
    }
  }

  double getBorderWidth(int index) {
    if (listAnswersStatus[index] == 'none') {
      return 1;
    } else if (listAnswersStatus[index] == 'true') {
      return 0;
    } else if (listAnswersStatus[index] == 'false') {
      return 0;
    } else {
      return 0.5;
    }
  }

  nextQuestion() {
    if (indexCurent + 1 >= listChoices.length) {
      setState(() {
        isShowResult = true;
      });
    }
    setState(() {
      listAnswersStatus = listAnswersStatus.map((e) => 'none').toList();
      isClick = false;
      indexCurent++;
    });
  }

  _buildSlider() {
    final answerRight =
        historyAnswers.where((e) => e['answer']).toList().length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${indexCurent + 1}/${listChoices.length}',
          style: kTitle,
        ),
        // SliderTheme(
        //   data: SliderTheme.of(context).copyWith(
        //       trackHeight: 10,
        //       overlayShape: RoundSliderOverlayShape(
        //         // Đặt đường viền cho cả hai đầu của Slider
        //         overlayRadius: 12.0,
        //       ),
        //       thumbColor: Colors.transparent,
        //       thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
        //   child: Slider(
        //     onChanged: (value) {
        //
        //     },
        //
        //     value: indexCurent.toDouble(),
        //     max: listChoices.length.toDouble(),
        //
        //   ),
        // )
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              LinearPercentIndicator(
                animation: true,
                lineHeight: 10.0,
                animationDuration: 0,
                percent: (indexCurent + 1) / listChoices.length,
                barRadius: const Radius.circular(20.0),
                progressColor: Colors.green.withOpacity(0.5),
              ),
              LinearPercentIndicator(
                animation: true,
                lineHeight: 7.0,
                backgroundColor: Colors.transparent,
                animationDuration: 0,
                percent: answerRight / listChoices.length,
                barRadius: const Radius.circular(15.0),
                progressColor: Colors.brown,
              ),
            ],
          ),
        ),
      ],
    );
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

  _buildResult() {
    return Stack(
      children: [
        CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
              elevation: 0,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [StretchMode.blurBackground],
                  background: _buildHeaderResult()),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 30, bottom: 5, right: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 3.0),
                            spreadRadius: 1,
                            blurRadius: 4.0,
                          ),
                        ],
                        border: Border.all(
                          color: secondaryColor,
                          width: 0.5
                        )
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText('${index + 1}.${historyAnswers[index]['title']}' ,
                              maxLines: 1,
                              style: kTitle.copyWith(
                              color: historyAnswers[index]['answer'] ? Colors.black : Colors.redAccent,
                              fontSize: 18
                            ),)),
                      ),
                    ),
                  );
                },
                childCount: historyAnswers.length,
              ),
            ),
          ],
        ),
        Positioned(
            bottom: 0,
            left: 30,
            right: 30,
            height: 40,
            child: GestureDetector(
              onTap: () {
                onDoAgain();
              },
              child: Container(
          decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              )
          ),
                child: Center(
                  child: Text('Làm lại', style: kTitle.copyWith(
                    color: primaryColor
                  ),),
                ),
        ),
            ))
      ],
    );
  }

  _buildHeaderResult() {
    final answerRight =
        historyAnswers.where((e) => e['answer']).toList().length;
    final res = (answerRight * 100 / listChoices.length).round();
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
           Text(
            'Kết quả',
            style: kTitle.copyWith(
              fontSize: 20
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: const Offset(0.0, 3.0),
                              spreadRadius: 4,
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text('$res%'),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: CircularPercentIndicator(
                      lineWidth: 10.0,
                      animationDuration: 2000,
                      percent: (res / 100).toDouble(),
                      animation: true,
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: secondaryColor,
                      radius: 60,
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
