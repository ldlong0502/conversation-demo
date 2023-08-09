import 'package:flutter/material.dart';
import 'package:untitled/blocs/list_kanji_cubit/list_kanji_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/blocs/word_cubit/list_word_cubit.dart';
import 'package:untitled/screens/kanji_screens/challenge1_page.dart';
import 'package:untitled/screens/kanji_screens/flashcard_page.dart';
import 'package:untitled/screens/grammar_screens/grammar_detail_page.dart';
import 'package:untitled/screens/grammar_screens/grammar_page.dart';
import 'package:untitled/screens/kanji_screens/kanji_detail_page.dart';
import 'package:untitled/screens/kanji_screens/kanji_page.dart';
import 'package:untitled/screens/kanji_screens/multiple_choice_page.dart';
import 'package:untitled/screens/listening_screens/practice_listening_detail_page.dart';
import 'package:untitled/screens/listening_screens/practice_listening_page.dart';
import 'package:untitled/screens/kanji_screens/practice_writing_page.dart';
import 'package:untitled/screens/word_screens/word_detail_page.dart';
import 'package:untitled/screens/word_screens/word_flashcard_page.dart';
import 'package:untitled/screens/word_screens/word_page.dart';
import '../screens/lesson_home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/word_screens/word_practice_page.dart';

class AppRoutes {
  static const homeLesson = '/homeLesson';
  static const practiceListening = '/practiceListening';
  static const practiceListeningDetail = '/practiceListeningDetail';
  static const kanji = '/kanji';
  static const kanjiDetail = '/kanjiDetail';
  static const vocabulary = '/vocabulary'; // từ vừng trong chữ hán
  static const grammar = '/grammar';
  static const grammarDetail = '/grammarDetail';
  static const practiceWriting = '/practiceWriting';
  static const flashcard = '/flashcard';
  static const multipleChoice = '/multipleChoice';
  static const challenge1 = '/challenge1';
  static const word = '/word'; //từ vừng màn hình home
  static const wordDetail = '/wordDetail';
  static const wordFlashcard = '/wordFlashcard';
  static const wordPractice = '/wordPractice';
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeLesson:
        {
          return MaterialPageRoute(
              builder: (context) => const LessonHomePage(),
              settings: settings);
        }
      case AppRoutes.practiceListening:
        {
          return MaterialPageRoute(
              builder: (context) => const PracticeListeningPage(),
              settings: settings);
        }
      case AppRoutes.practiceListeningDetail:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                      value: map['currentLessonCubit'] as CurrentLessonCubit,
                      child:  PracticeListeningDetailPage(
                          positionNow: map['positionNow'])),
              settings: settings);
        }
      case AppRoutes.kanji:
        {
          return MaterialPageRoute(
              builder: (context) => const KanjiPage(), settings: settings);
        }

      case AppRoutes.kanjiDetail:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                    value: map['listKanjiCubit'] as ListKanjiCubit,
                    child: KanjiDetailPage(map['kanji']),
                  ),
              settings: settings);
        }
      case AppRoutes.word:
        {
          return MaterialPageRoute(
              builder: (context) => const WordPage(), settings: settings);
        }
      case AppRoutes.wordDetail:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                    value: map['listWordCubit'] as ListWordCubit,
                    child: const WordDetailPage(),
                  ),
              settings: settings);
        }
      case AppRoutes.wordFlashcard:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                    value: map['listWordCubit'] as ListWordCubit,
                    child:  WordFlashCardPage(listWord: map['listWord']),
                  ),
              settings: settings);
        }
      case AppRoutes.wordPractice:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                    value: map['listWordCubit'] as ListWordCubit,
                    child:  WordPracticePage(listWord: map['listWord']),
                  ),
              settings: settings);
        }
      case AppRoutes.grammar:
        {
          return MaterialPageRoute(
              builder: (context) => const GrammarPage(), settings: settings);
        }
      case AppRoutes.grammarDetail:
        {
          return MaterialPageRoute(
              builder: (context) => const GrammarDetailsPage(),
              settings: settings);
        }
      case AppRoutes.practiceWriting:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                    value: map['listKanjiCubit'] as ListKanjiCubit,
                    child: PracticeWritingPage(kanji: map['kanji'],),
                  ),
              settings: settings);
        }
      case AppRoutes.flashcard:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                    value: map['listKanjiCubit'] as ListKanjiCubit,
                    child: FlashCardPage(listKanjis: map['listKanjis']),
                  ),
              settings: settings);
        }
      case AppRoutes.multipleChoice:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                      value: map['listKanjiCubit'] as ListKanjiCubit,
                      child: const MultipleChoicePage()),
              settings: settings);
        }
      case AppRoutes.challenge1:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) =>
                  BlocProvider.value(
                    value: map['listKanjiCubit'] as ListKanjiCubit,
                    child: Challenge1Page(listKanjis: map['listKanjis']),
                  ),
              settings: settings);
        }
    }

    return null;
  }
}
