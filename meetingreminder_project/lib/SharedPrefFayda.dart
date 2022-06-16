import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefFayda{


  static prefKaydet(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email',email);

  }
  static prefAdminKaydet(adminControl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('adminMi',adminControl);

  }

  static Future<String> getEmailPref () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email').toString();
  }







}