import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/features/listening/listening_detail_action.dart';
import 'package:untitled/features/listening/slider_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppbarDetailPlayer extends StatelessWidget {
  const AppbarDetailPlayer({Key? key, required this.positionNow}) : super(key: key);
  final Duration positionNow;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
              headerTitle(context),
              const SizedBox(
                height: 20,
              ),
              const ListeningDetailAction(),
              const SizedBox(
                height: 20,
              ),
               SliderBar(positionNow: positionNow)
            ],
          )),
    );
  }

  headerTitle(BuildContext context) {
    final lesson = context.read<CurrentLessonCubit>().state!;
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
                  lesson.mean,
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
