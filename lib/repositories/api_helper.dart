import 'dart:io';
import 'package:flutter/material.dart';
class ApiHelper {
  static const apiKey = "http://173.199.127.90:3000/api/v1/mobile/static/get/?token=6f0108183566ebcef2f8723984dccc8d473ff4a47f41339688f40403a87c28d1c36b728b4e2d8a222ab770ac18be872b7b18937f5d86288d3cdf691a5bcf4c8d&name=";


  ApiHelper._privateConstructor();
  static final ApiHelper instance = ApiHelper._privateConstructor();

  String getLinkMp3(String file){
    print(apiKey + file);
    return apiKey + file;
  }


}