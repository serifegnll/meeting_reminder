import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefFayda{


  static prefEmailKaydet(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email',email);
  }

  static prefEmailSil(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
  }
  static Future<String> getEmailPref () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email').toString();
  }

  static Color gecmisToplantilarColor = Color(0xFFFFFFFF);
  static Color gelecekToplantilarColor = Color(0xFFFFFFFF);








}