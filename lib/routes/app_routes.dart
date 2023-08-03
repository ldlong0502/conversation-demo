import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_cubit/kanji_cubit.dart';
import 'package:untitled/blocs/list_kanji_cubit/list_kanji_cubit.dart';
import 'package:untitled/pages/challenge1_page.dart';
import 'package:untitled/pages/flashcard_page.dart';
import 'package:untitled/pages/grammar_detail_page.dart';
import 'package:untitled/pages/grammar_page.dart';
import 'package:untitled/pages/kanji_detail_page.dart';
import 'package:untitled/pages/kanji_page.dart';
import 'package:untitled/pages/multiple_choice_page.dart';
import 'package:untitled/pages/practice_listening_detail_page.dart';
import 'package:untitled/pages/practice_listening_page.dart';
import 'package:untitled/pages/practice_writing_page.dart';
import '../models/kanji.dart';
import '../pages/lesson_home_page.dart';

class AppRoutes {
  static const homeLesson = '/homeLesson';
  static const practiceListening = '/practiceListening';
  static const practiceListeningDetail = '/practiceListeningDetail';
  static const kanji = '/kanji';
  static const kanjiDetail = '/kanjiDetail';
  static const vocabulary = '/vocabulary';
  static const grammar = '/grammar';
  static const grammarDetail = '/grammarDetail';
  static const practiceWriting = '/practiceWriting';
  static const flashcard = '/flashcard';
  static const multipleChoice = '/multipleChoice';
  static const challenge1 = '/challenge1';



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
          return MaterialPageRoute(
              builder: (context) => const PracticeListeningDetailPage(),
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
              builder: (context) => KanjiDetailPage(map['kanji']),
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
              builder: (context) => PracticeWritingPage( kanji: map['kanji'],),
              settings: settings);
        }
      case AppRoutes.flashcard:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) => FlashCardPage(listKanjis: map['listKanjis']),
              settings: settings);
        }
      case AppRoutes.multipleChoice:
        {

          return MaterialPageRoute(
              builder: (context) => const MultipleChoicePage(),
              settings: settings);
        }
      case AppRoutes.challenge1:
        {
          Map map = settings.arguments as Map;
          return MaterialPageRoute(
              builder: (context) => Challenge1Page(listKanjis: map['listKanjis']),
              settings: settings);
        }
    }

    return null;
  }
}