import 'package:flutter/material.dart';
import 'package:untitled/blocs/list_kanji_cubit/list_kanji_cubit.dart';
import 'package:untitled/features/kanji/action_animation_position.dart';
import 'package:untitled/features/kanji/grid_view_kanji.dart';
import '../../configs/app_color.dart';
import '../../enums/app_text.dart';
import '../../models/kanji.dart';
import '../../widgets/app_bar_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_progress.dart';

class KanjiPage extends StatelessWidget {
  const KanjiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarCustom(
            title: AppTextTranslate.getTranslatedText(EnumAppText.txtKanji),
            bgColor: AppColor.blue,
            textColor: AppColor.white,
          ),
        ),
        body: BlocProvider(
          create: (context) => ListKanjiCubit()..getData(),
          child: BlocBuilder<ListKanjiCubit, List<Kanji>?>(
            builder: (context, state) =>
            state == null
                ? const LoadingProgress()
                : Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(10).copyWith(bottom: 0),
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      color: AppColor.whiteAccent1,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        GridViewKanji(listKanjis: state),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
                ActionAnimationPosition(listKanjis: state)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
