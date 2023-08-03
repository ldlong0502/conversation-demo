import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_challenge1_cubit/kanji_challenge1_cubit.dart';

import '../../../configs/app_color.dart';
import '../../../configs/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AlertNotifyChallenge extends StatelessWidget {
  const AlertNotifyChallenge({Key? key, required this.state}) : super(key: key);
  final KanjiChallenge1Loaded state;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = MediaQuery.of(context).size.height - kToolbarHeight;
    final cubit = context.watch<KanjiChallenge1Cubit>();

    return AnimatedPositioned(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      top: state.isShowingDialog ? size.height * 0.2 : -size.height * 0.5,
      left: size.width * 0.1,
      right: size.width * 0.1,
      child: Stack(
        children: [
          Container(
              height: height * 0.5,
              decoration: BoxDecoration(
                  color: AppColor.white,
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
                  Text(
                    getItem()['title']!,
                    style: AppStyle.kTitle
                        .copyWith(color: AppColor.red, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      getItem()['content']!,
                      textAlign: TextAlign.center,
                      style: AppStyle.kTitle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14),
                    ),
                  )
                ],
              )),
          Positioned(
              height: 30,
              width: 50,
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                      border: Border.all(color: AppColor.red),
                      color: AppColor.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0.0, 3.0),
                          spreadRadius: 2,
                          blurRadius: 4.0,
                        ),
                      ]),
                  child: const Center(
                    child: Icon(
                      Icons.clear_rounded,
                      color: AppColor.red,
                      size: 15,
                    ),
                  ),
                ),
              )),
          Positioned(
              bottom: 30,
              height: 30,
              left: (size.width * 0.8 - 120) / 2,
              width: 120,
              child: GestureDetector(
                onTap: () {
                  cubit.onDoAgain();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColor.red,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.red.withOpacity(0.4),
                          offset: const Offset(0.0, 3.0),
                          spreadRadius: 4,
                          blurRadius: 4.0,
                        ),
                      ]),
                  child: Center(
                      child: Text(
                    'Làm lại',
                    style: AppStyle.kTitle.copyWith(color: AppColor.white),
                  )),
                ),
              ))
        ],
      ),
    );
  }

  Map getItem() {
    if (state.indexCurrent + 1 == state.listQuestion.length) {
      return {
        'title': 'Chúc mừng',
        'content': 'Bạn thật xuất sắc khi đã hoàn thành toàn bộ thử thách!',
        'icon': 'assets/images/ic_success.png'
      };
    }
    return {
      'title': 'Thất bại',
      'content':
          'Bạn đã không thể vượt qua thử thách này. Cố gắng lần tiếp theo nha!',
      'icon': 'assets/images/ic_failed.png'
    };
  }
}
