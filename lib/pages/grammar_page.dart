import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/grammar/list_view_grammar.dart';
import 'package:untitled/models/grammar.dart';
import 'package:untitled/routes/app_routes.dart';
import 'package:untitled/widgets/loading_progress.dart';

import '../blocs/grammar_cubit/grammar_cubit.dart';
import '../configs/app_color.dart';
import '../enums/app_text.dart';
import '../widgets/app_bar_custom.dart';

class GrammarPage extends StatelessWidget {
  const GrammarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarCustom(
            title: AppTextTranslate.getTranslatedText(EnumAppText.txtGrammar),
            bgColor: AppColor.blue,
            textColor: AppColor.white,
          ),
        ),
        body: BlocBuilder<GrammarCubit, GrammarState>(
          builder: (context, state) {
            if(state is GrammarLoaded){
              return ListViewGrammar(listGrammar: state.listGrammars);
            }
            return const LoadingProgress();

          }
        ),
      ),
    );
  }
}