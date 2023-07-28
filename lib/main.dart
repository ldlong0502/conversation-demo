
import 'package:flutter/material.dart';
import 'package:untitled/blocs/bloc_conversation/conversation_bloc.dart';
import 'package:untitled/blocs/bloc_grammar/grammar_bloc.dart';
import 'package:untitled/blocs/bloc_kanji/kanji_bloc.dart';
import 'package:untitled/blocs/bloc_lesson/lesson_bloc.dart';
import 'package:untitled/repositories/database_grammar_helper.dart';
import 'package:untitled/repositories/database_kanji_helper.dart';
import 'package:untitled/repositories/database_listening_helper.dart';
import 'package:untitled/views/screens/lesson_home_screen.dart';
import 'package:untitled/views/screens/list_screen.dart';
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
          create: (context) => LessonBloc()..add(const GetAllLessons()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ConversationBloc(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => GrammarBloc()..add(const GetAllGrammars()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => KanjiBloc()..add(const GetAllKanjis()),
        ),
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
      home: const LessonHomeScreen()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _gotoListScreen()  async {

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ListScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoListScreen,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
