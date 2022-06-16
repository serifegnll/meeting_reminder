import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meetingreminder_project/SharedPrefFayda.dart';
import 'package:meetingreminder_project/add_user.dart';
import 'package:meetingreminder_project/reminder_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_meeting.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color: Colors.black,
      )),
      home: SharedPrefFayda.getEmailPref() == null
          ? LoginPage()
          : ReminderPage(),
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
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
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      labelText: 'Email',
                      hintText: 'E-mail adresinizi yazınız'))),
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
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  labelText: 'Password',
                  hintText: 'Şifrenizi giriniz'),
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
                  SharedPrefFayda.prefKaydet(_email);

                  if (await loginUserEmailAndPassword() == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReminderPage()));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: new Text("Giriş Yapılamadı"),
                              content: new Text(
                                  "Lütfen giriş bilgilierinizi kontrol ediniz."),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  child: new Text("Tamam"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ]);
                        });
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddUserPage()));
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
