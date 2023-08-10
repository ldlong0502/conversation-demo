import 'package:flutter/material.dart';
import 'package:untitled/blocs/list_kanji_cubit/list_kanji_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import '../../models/kanji.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class GridViewAction extends StatelessWidget {
  const GridViewAction(
      {Key? key, required this.listKanjis})
      : super(key: key);
  final List<Kanji> listKanjis;

  @override
  Widget build(BuildContext context) {
    var listItems = [
      {
        'title': 'Chi tiết',
        'iconUrl': 'assets/images/ic_detailed.png',
        'onPress': () {
          Navigator.pushNamed(
            context,
            AppRoutes.kanjiDetail,
            arguments: {
              'kanji': listKanjis[0],
              'listKanjiCubit': context.read<ListKanjiCubit>()
            },
          );
        }
      },
      {
        'title': 'Luyện Viết',
        'iconUrl': 'assets/images/ic_draw.png',
        'onPress': () {
          Navigator.pushNamed(
            context,
            AppRoutes.practiceWriting,
            arguments: {
              'kanji': listKanjis[0],
              'listKanjiCubit': context.read<ListKanjiCubit>()
            },

          );
        }
      },
      {
        'title': 'Flashcard',
        'iconUrl': 'assets/images/ic_flashcard.png',
        'onPress': () {
          Navigator.pushNamed(
            context,
            AppRoutes.flashcard,
            arguments: {
              'listKanjis': listKanjis,
              'listKanjiCubit': context.read<ListKanjiCubit>()},
          );
        }
      },
      {
        'title': 'Trắc Nghiệm',
        'iconUrl': 'assets/images/ic_practise.png',
        'onPress': () {
          Navigator.pushNamed(
            context,
            AppRoutes.multipleChoice,
            arguments: {'listKanjiCubit': context.read<ListKanjiCubit>()},
          );
        }
      },
      {
        'title': 'Thử thách 1',
        'iconUrl': 'assets/images/ic_changellenge_1.png',
        'onPress': () {
          Navigator.pushNamed(
            context,
            AppRoutes.challenge1,
            arguments: {
              'listKanjis': listKanjis,
              'listKanjiCubit': context.read<ListKanjiCubit>()
            },
          );
        }
      },
      {
        'title': 'Thử thách 2',
        'iconUrl': 'assets/images/ic_changellenge_1.png',
        'onPress': () {}
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 0 // Số cột
            ),
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return RawMaterialButton(
            onPressed: listItems[index]['onPress'] as Function(),
            shape: const CircleBorder(),
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    listItems[index]['iconUrl'] as String,
                    fit: BoxFit.cover,
                    height: 50,
                    color: AppColor.white,
                  ),
                  Text(listItems[index]['title'] as String,
                      style: AppStyle.kTitle
                          .copyWith(color: AppColor.white , fontSize: 13)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
