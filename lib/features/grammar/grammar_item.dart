import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:untitled/routes/app_routes.dart';
import '../../models/grammar.dart';
class GrammarItem extends StatelessWidget {
  const GrammarItem({Key? key, required this.grammar}) : super(key: key);
  final Grammar grammar;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(color: AppColor.blue, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 4,
                blurRadius: 4.0,
              )
            ],
            borderRadius: BorderRadius.circular(50)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () async {
              Navigator.pushNamed(context, AppRoutes.grammarDetail, arguments: grammar);
            },
            child: SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppColor.blue),
                      alignment: Alignment.center,
                      child: const Icon(Icons.circle,
                          color: Colors.white, size: 8),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(grammar.mean.toUpperCase(),
                            style: AppStyle.kTitle, maxLines: 1),
                        Text('(${grammar.title})',
                            style: AppStyle.kSubTitle, maxLines: 1),
                      ],
                    ),
                  ),
                  const Expanded(
                      child: Icon(
                    Icons.navigate_next_outlined,
                    size: 30,
                    color: AppColor.blue,
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}
