import 'dart:io';

import 'package:untitled/models/conversation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
import 'package:untitled/repositories/database_listening_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConversationRepository {
  ConversationRepository._privateConstructor();

  static final ConversationRepository _instance = ConversationRepository._privateConstructor();

  static ConversationRepository get instance => _instance;

  final DatabaseListeningHelper dataHelper = DatabaseListeningHelper.instance;

  Future<List<Conversation>> getAllLessons(int lesson) async{


    final List<Map<String, dynamic>> result = await dataHelper.queryAllRows('SELECT * FROM sentence where lesson = $lesson');
    final listConservations = result.map((row) => Conversation.fromJson(row)).toList();
    return listConservations;
  }

  Future setBlur(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('blur', value);
  }
  Future<bool> getBlur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isBlur;
    isBlur = prefs.getBool('blur') ?? true;
    setBlur(isBlur);
    return isBlur;
  }
  Future setTranslate(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('translate', value);
  }
  Future<bool> getTranslate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTranslate;
    isTranslate = prefs.getBool('translate') ?? true;
    setTranslate(isTranslate);
    return isTranslate;
  }
  Future setPhonetic(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('phonetic', value);
  }
  Future<bool> getPhonetic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPhonetic;
    isPhonetic = prefs.getBool('phonetic') ?? true;
    setPhonetic(isPhonetic);
    return isPhonetic;
  }
}