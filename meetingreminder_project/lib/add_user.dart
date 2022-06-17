import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  int login = 0;
  final emailController = TextEditingController();
  final sifreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Kaydol')),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kaydol\n",
              style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        labelText: 'Email',
                        hintText: 'Email adresiniz'))),
            SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                    controller: sifreController,

                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        labelText: 'Şifre',
                        hintText: 'Şifre adresiniz'))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      email = emailController.text;
                      password = sifreController.text;
                      userEkle();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));


                    },
                    child: Text("KAYDOL"))
              ]),
            )
          ],
        )));
  }

  userEkle() async{

    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      debugPrint(_userCredential.toString());
      login = 1;
    } catch (e) {
      login = 0;
      //print(e.toString());
    }
    return login;


  }
}
