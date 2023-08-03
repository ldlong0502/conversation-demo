import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/models/kanji.dart';
import 'package:untitled/routes/app_routes.dart';
import '../../configs/app_style.dart';

class GridViewKanji extends StatelessWidget {
  const GridViewKanji({Key? key, required this.listKanjis}) : super(key: key);
  final List<Kanji> listKanjis;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
            mainAxisSpacing: 10 // Số cột
            ),
        itemCount: listKanjis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.kanjiDetail, arguments: {
              'kanji': listKanjis[index],
            },),
            child: Container(
              decoration: BoxDecoration(
                color: listKanjis[index]!.isHighLight
                    ? AppColor.blue
                    : AppColor.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColor.blue, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(3.0, 8.0),
                    spreadRadius: 2,
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    listKanjis[index]!.kanji,
                    style: AppStyle.kTitle.copyWith(
                        color: !listKanjis[index].isHighLight
                            ? AppColor.blue
                            : AppColor.white,
                        fontSize: 20),
                  ),
                  Text(listKanjis[index]!.vi,
                      style: AppStyle.kTitle.copyWith(
                        color: !listKanjis[index]!.isHighLight
                            ? AppColor.blue
                            : AppColor.white,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
