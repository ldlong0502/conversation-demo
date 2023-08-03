
import 'package:flutter/material.dart';
import '../../../blocs/kanji_challenge1_cubit/kanji_challenge1_cubit.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class GridAnswer extends StatelessWidget {
  const GridAnswer({Key? key, required this.state}) : super(key: key);
  final KanjiChallenge1Loaded state;
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<KanjiChallenge1Cubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: GridView.builder(
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

              cubit.onClick(index);
              // if (_isClick) return;
              // setState(() {
              //   _isClick = true;
              // });
              // _timer.cancel();
              // checkAnswer(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: getColor(index),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: getBorderColor(index), width: getBorder(index)),
                boxShadow: [
                  state.listDataAnswer[index]['status'] != 'none'
                      ? const BoxShadow()
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
                    state.listDataAnswer[index]['item'].kanji,
                    style: AppStyle.kTitle.copyWith(
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
    if (state.listDataAnswer[index]['status'] == 'none') {
      return  AppColor.white;
    } else if (state.listDataAnswer[index]['status'] == 'true') {
      return  AppColor.green;
    } else if (state.listDataAnswer[index]['status'] == 'false') {
      return  AppColor.red;
    } else {
      return  AppColor.old;
    }
  }

  double getBorder(int index) {
    if (state.listDataAnswer[index]['status'] == 'none') {
      return 1;
    } else {
      return 0;
    }
  }
  getTextColor(int index) {
    if (state.listDataAnswer[index]['status'] == 'none') {
      return AppColor.green;
    } else if (state.listDataAnswer[index]['status'] == 'true') {
      return AppColor.white;
    } else if (state.listDataAnswer[index]['status'] == 'false') {
      return AppColor.white;
    } else {
      return AppColor.green;
    }
  }

  getBorderColor(int index) {
    if (state.listDataAnswer[index]['status'] == 'none') {
      return AppColor.green;
    } else if (state.listDataAnswer[index]['status'] == 'true') {
      return AppColor.green;
    } else if (state.listDataAnswer[index]['status'] == 'false') {
      return AppColor.red;
    } else {
      return AppColor.old;
    }
  }
}
