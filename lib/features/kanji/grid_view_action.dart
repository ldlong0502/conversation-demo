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
        'iconUrl': 'assets/images/ic_detail.png',
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
        'iconUrl': 'assets/images/ic_write.png',
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
        'iconUrl': 'assets/images/ic_card.png',
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
        'iconUrl': 'assets/images/ic_choice.png',
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
        'iconUrl': 'assets/images/ic_challenge.png',
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
        'iconUrl': 'assets/images/ic_challenge.png',
        'onPress': () {}
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
            shape: const CircleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  listItems[index]['iconUrl'] as String,
                  height: 35,
                  fit: BoxFit.cover,
                ),
                Text(listItems[index]['title'] as String,
                    style: AppStyle.kTitle
                        .copyWith(color: AppColor.white, fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }
}
