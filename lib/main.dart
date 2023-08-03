
import 'package:flutter/material.dart';
import 'package:untitled/blocs/grammar_cubit/grammar_cubit.dart';
import 'package:untitled/blocs/list_kanji_cubit/list_kanji_cubit.dart';
import 'package:untitled/blocs/listening_effect_cubit/listening_effect_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_list_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_player_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/listening_list_cubit.dart';
import 'package:untitled/repositories/database_grammar_helper.dart';
import 'package:untitled/repositories/database_kanji_helper.dart';
import 'package:untitled/repositories/database_listening_helper.dart';
import 'package:untitled/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseListeningHelper.instance.unzipFileFromAssets('assets/databases/listening_n5.zip');
  await DatabaseGrammarHelper.instance.unzipFileFromAssets('assets/databases/grammar.zip');
  await DatabaseKanjiHelper.instance.unzipFileFromAssets('assets/databases/kanji.zip');
  runApp( MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => GrammarCubit()..getData()),
        BlocProvider(
            lazy: false,
            create: (context) => ListKanjiCubit()..getData()),
        BlocProvider(
            lazy: false,
            create: (context) => ListeningListCubit()..getData()),
        BlocProvider(
            lazy: false,
            create: (context) => CurrentLessonCubit()),
        BlocProvider(
            lazy: false,
            create: (context) => ConversationListCubit()),
        BlocProvider(
            lazy: false,
            create: (context) => ConversationPlayerCubit()),
        BlocProvider(
            lazy: false,
            create: (context) => ListeningEffectCubit()..load()),
      ],
      child: const MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.homeLesson,
    );
  }
}

