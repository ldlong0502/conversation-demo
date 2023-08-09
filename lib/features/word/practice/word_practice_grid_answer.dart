
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/blocs/word_practice_cubit/word_practice_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/repositories/word_repository.dart';
import '../../../configs/app_color.dart';
import '../../../enums/status_answer.dart';
class WordPracticeGridAnswer extends StatelessWidget {
  const WordPracticeGridAnswer({Key? key, required this.state}) : super(key: key);
  final WordPracticeLoaded state;
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<WordPracticeCubit>();
    final repo = WordRepository.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            mainAxisSpacing: 8 // Số cột
        ),
        itemCount: state.listAnswers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {

              cubit.onClick(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: getColor(index),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: getBorderColor(index), width: getBorder(index)),
                boxShadow: [
                  state.listAnswers[index]['status'] != StatusAnswer.normal
                      ? const BoxShadow()
                      : BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0.0, 8.0),
                    spreadRadius: 2,
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Image.file(
                File(repo.getUrlImageById(state.listAnswers[index]['item'].id))
              )
            ),
          );
        },
      ),
    );
  }
  getColor(int index) {
    if (state.listAnswers[index]['status'] == StatusAnswer.normal) {
      return  AppColor.white;
    } else if (state.listAnswers[index]['status'] == StatusAnswer.right) {
      return  AppColor.green;
    } else if (state.listAnswers[index]['status'] == StatusAnswer.wrong) {
      return  AppColor.red;
    } else {
      return  AppColor.old;
    }
  }

  double getBorder(int index) {
    if (state.listAnswers[index]['status'] == StatusAnswer.normal) {
      return 1;
    } else {
      return 0;
    }
  }
  getBorderColor(int index) {
    if (state.listAnswers[index]['status'] == StatusAnswer.normal) {
      return AppColor.orange;
    } else if (state.listAnswers[index]['status'] == StatusAnswer.right) {
      return AppColor.green;
    } else if (state.listAnswers[index]['status'] == StatusAnswer.wrong) {
      return AppColor.red;
    } else {
      return AppColor.old;
    }
  }
}
