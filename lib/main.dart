
import 'package:flutter/material.dart';
import 'package:untitled/blocs/download_cubit/download_cubit.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/database_word_helper.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseListeningHelper.instance.unzipFileFromAssets('assets/databases/listening_n5.zip');
  await DatabaseGrammarHelper.instance.unzipFileFromAssets('assets/databases/grammar.zip');
  await DatabaseKanjiHelper.instance.unzipFileFromAssets('assets/databases/kanji.zip');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp( MultiBlocProvider(providers: [
    BlocProvider(create: (context) => DownloadCubit())
  ], child: const MyApp()));
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

