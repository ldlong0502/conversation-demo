import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_player_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/features/listening/listening_detail_action.dart';
import 'package:untitled/features/listening/slider_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/lesson.dart';

class AppbarDetailPlayer extends StatelessWidget {
  const AppbarDetailPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ConversationPlayerCubit>();
    return SafeArea(
      child: Container(
          height: 180,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
            color: AppColor.white,
          ),
          child: Column(
            children: [
              headerTitle(context , cubit.state!),
              const SizedBox(
                height: 20,
              ),
              const ListeningDetailAction(),
              const SizedBox(
                height: 20,
              ),
              const SliderBar()
            ],
          )),
    );
  }

  headerTitle(BuildContext context ,Lesson lesson) {
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
                  color: AppColor.blue,
                )),
          ),
        ),
        Expanded(
            flex: 3,
            child: Center(
                child: Text(
                  lesson.vi,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColor.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ))),
        Expanded(child: Container())
      ],
    );
  }

}
