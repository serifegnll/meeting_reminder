
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meetingreminder_project/reminder_page.dart';
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

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    messaging.subscribeToTopic("messaging");
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 60, 60, 60),
        )
      ),
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
  int login = 0;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void fcmSubscribe() {
    firebaseMessaging.subscribeToTopic('TopicToListen');
  }
  @override
  void initState() {
    fcmSubscribe();

    super.initState();
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('user offline');
      } else {
        debugPrint('user online');
      }
    });
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myEmailController.dispose();
    myPassController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(title: Text('Giriş Yap')), //ustteki bar
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      "Hoşgeldiniz!\n", //karşılama yazısı
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                  )),
              Padding(
                  //email kısmı
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                      controller: myEmailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 2.0),),
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
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 2.0),),
                      labelText: 'Password',
                      hintText: 'Password'),
                ),
              ),
              Padding(
                // ******GİRİŞ YAP*****
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () async {
                      _email = myEmailController.text;
                      _password = myPassController.text;
                      if (await loginUserEmailAndPassword() == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReminderPage()));
                      } else {
                        //buraya error mesajını pop up gibi bişeyle götermem lazım
                      }
                    },
                    child: Text("GİRİŞ YAP")),
              ),
              Padding(
                //*******KAYDOL*********
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      _email = myEmailController.text;
                      _password = myPassController.text;
                      createUserEmailAndPassword();
                    },
                    child: Text("KAYDOL")),
              ),
            ])));
  }

  createUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      debugPrint(_userCredential.toString());
      login = 1;
    } catch (e) {
      login = 0;
      //print(e.toString());
    }
    return login;
  }

  loginUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
          email: _email.trimLeft(), password: _password);
      debugPrint(_userCredential.toString());
      login = 1;
    } catch (e) {
      login = 0;
      //print(e.toString());
    }
    return login;
  }
}
