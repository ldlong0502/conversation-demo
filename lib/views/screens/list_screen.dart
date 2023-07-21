import 'package:flutter/material.dart';
import 'package:untitled/blocs/bloc_lesson/lesson_bloc.dart';
import 'package:untitled/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/lesson.dart';
import 'package:untitled/views/screens/conversation_screen.dart';

import '../../blocs/bloc_conversation/conversation_bloc.dart';
import '../../repositories/audio_helper.dart';
import '../widgets/circle_progress_bar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  @override
  void initState() {
    super.initState();
    context
        .read<LessonBloc>()
        .add(const GetAllLessons());
    }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        if(state is LessonLoaded){
          return Scaffold(
            backgroundColor: Colors.white.withOpacity(0.99),
            body: Stack(
              children: [
                listViewScroll(),
                headerPlayer(context),
              ],
            ),
          );
        }
        else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),);
        }
      }
    );
  }

  listViewScroll() {
    return BlocBuilder<LessonBloc, LessonState>(
        builder: (context, state) {
          if (state is LessonLoaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 150, right: 10, left: 10),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.listLessons.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      height: 55,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border.all(color: secondaryColor, width: 1),
                          borderRadius: BorderRadius.circular(50)),
                      child: lessonItem(state.listLessons[idx]),
                    );
                  }),
            );
          }
          else {
            return Container();
          }
        }
    );
  }

  headerPlayer(BuildContext context) {
    return Container(
      height: 150,
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
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          headerTitle(context),
          controlPlayer(),
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
        const Expanded(
            flex: 1,
            child: Center(
                child: Text(
                  'Sơ Cấp 1',
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ))),
        Expanded(child: Container())
      ],
    );
  }

  controlPlayer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.compare_arrows,
              color: secondaryColor,
              size: 35,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.skip_previous,
              color: secondaryColor,
              size: 40,
            )),
        CircleAvatar(
          radius: 30,
          backgroundColor: secondaryColor,
          child: BlocBuilder<LessonBloc, LessonState>(
            builder: (context, state) {

              if (state is LessonLoaded) {
                print("${state.isPlaying} hiiii");
                return IconButton(
                    onPressed: () async {

                      if (state.isPlaying) {
                        context.read<LessonBloc>().add(LessonStopped());
                      }
                      else {
                        context.read<LessonBloc>().add(
                            LessonListening(lesson: state.lessonPlaying));
                      }
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    icon: Icon(
                      state.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: primaryColor,
                      size: 40,
                    ));
              }
              else {
                return Container();
              }
            },
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.skip_next,
              color: secondaryColor,
              size: 40,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.replay_rounded,
              color: secondaryColor,
            )),
      ],
    );
  }
  _goToConversation(Lesson item) async {
    context.read<ConversationBloc>()
        .add(GetAllConversations(idLesson: item.id));
    // context.read<LessonBloc>()
    //     .add(LessonUpdateDurationMax(lesson: item));
    final duration =  await AudioHelper.instance.getDuration(item.mp3);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  ConversationScreen(lesson: item.copyWith(durationMax: duration),)));
  }
  lessonItem(Lesson item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () async {
          print('long' + item.durationMax.inMilliseconds.toString());
          context.read<LessonBloc>().add(LessonStopped());
          _goToConversation(item);
        },
        child: SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<LessonBloc, LessonState>(
                    builder: (context, state) {
                      if (state is LessonLoaded) {
                        return GestureDetector(
                          onTap: () async {
                            if (!item.isPlaying) {
                              context.read<LessonBloc>().add(
                                  LessonListening(lesson: item));
                            }
                            else {
                              context.read<LessonBloc>().add(LessonStopped());
                              _goToConversation(item);
                            }
                          },

                          child: item.isPlaying ? Container(
                            height: 25,
                            width: 25,

                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            child: CircularProgressBar(
                              audioPlayer: state.audioPlayer,
                              durationCurrent: item.durationCurrent,
                              durationMax: item.durationMax,
                            ),
                          ) : Container(
                            height: 35,
                            width: 35,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: secondaryColor
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                                item.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white, size: 30),
                          ),
                        );
                      }
                      else {
                        return Container();
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.vi, style: kTitle, maxLines: 1),
                      Text(item.title, style: kSubTitle, maxLines: 1),
                    ],
                  ),
                ),
                const Expanded(child: Icon(
                  Icons.navigate_next_outlined, size: 30, color: secondaryColor,)),
              ],
            ),
          ),

      ),
    );
  }
}

