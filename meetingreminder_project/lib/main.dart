// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _email = "";
  String _password = "";
  final myEmailController = TextEditingController();
  final myPassController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myEmailController.dispose();
    myPassController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(title: Text('Login Page')), //ustteki bar
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      "Welcome Back!\n", //karşılama yazısı
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                  )),
              Padding(
                  //email kısmı
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                      controller: myEmailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter your e-mail adress'))),
              Padding(
                //password kısmı
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  controller: myPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Password'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                    onPressed: () {
                      _email = myEmailController.text;
                      _password = myPassController.text;
                      loginUserEmailAndPassword();
                      //print(_email);
                      //print(_password);
                    },
                    child: Text("LOGIN")),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                    onPressed: () {
                      _email = myEmailController.text;
                      _password = myPassController.text;
                      createUserEmailAndPassword();
                    },
                    child: Text("CREATE ACCOUNT")),
              ),
            ])));
  }

  void createUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      debugPrint(_userCredential.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void loginUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      debugPrint(_userCredential.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
