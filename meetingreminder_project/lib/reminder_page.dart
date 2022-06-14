import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:meetingreminder_project/expired_meetings.dart';
import 'package:meetingreminder_project/viewModel.dart';
import 'add_meeting.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  var adminControl = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    adminKontrol();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toplantılar"),
        actions: [
          adminControl == true
              ? IconButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddMeetingPage()));
                  },
                  icon: const Icon(Icons.add))
              : Container(),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromARGB(255, 60, 60, 60)),
              ),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ExpiredPage()));
              },
              child: Text('Geçmiş Toplantılar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))
        ],
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('toplantilar').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            return ListView.builder(
                itemCount: streamSnapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return listItem(index, streamSnapshot);
                });
          }),
    );
  }

  Widget listItem(int index, streamSnapshot) {
    return Card(
      color: Colors.blueGrey[60],
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      elevation: 20,
      margin: EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Column(children: [
          Container(
            height: 60,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  streamSnapshot.data?.docs[index]['baslik'].toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: CountdownTimer(
                    endTime:
                        dateParse(streamSnapshot.data?.docs[index]['tarihsaat'])
                            .millisecondsSinceEpoch,
                    textStyle: TextStyle(fontSize: 12, color: Colors.white),
                    onEnd: () async {
                      await NotificationVM.bildirimGonder('Toplantı Başladı' , streamSnapshot.data?.docs[index]['baslik'].text); // BURAYA Bİ BAK SONRA
                      await bitenToplantiyiAl(index,streamSnapshot);
                    }
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30)),
              color: Colors.black87,
            ),
          ),
          Container(
              // etiketlerin olduğu
              child: Row(children: [
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text('Toplantı Konusu: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            streamSnapshot.data?.docs[index]['konu'],
                            textAlign: TextAlign.left,
                          )),
                    ])),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.red, width: 3.0),
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text('Toplantı Zamanı: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          streamSnapshot.data?.docs[index]['tarihsaat'],
                          textAlign: TextAlign.left,
                        )),
                  ])),
              new Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 0,
                color: Colors.black,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text('Toplantı Mekanı: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          streamSnapshot.data?.docs[index]['mekan'],
                          textAlign: TextAlign.left,
                        )),
                  ])),
              const Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 0,
                color: Colors.black,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text('Departman: ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          streamSnapshot.data?.docs[index]['departman'],
                          textAlign: TextAlign.left,
                        )),
                  ]))
            ]),
          ])),
        ]),
      ),
    );
  }

  bool emailYazdirma() {
    var email = FirebaseAuth.instance.currentUser?.email.toString();
    if (email == "serifegonullu77@gmail.com") {
      return false;
    }
    return true;
  }

  DateTime dateParse(String date) {
    var parsedDate = DateFormat("dd-M-yyyy hh:mm:ss").parse(date);
    return parsedDate;
  }

  Future<bool> adminKontrol() async {
    var email = FirebaseAuth.instance.currentUser?.email.toString();
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('admins').get();
    final List<DocumentSnapshot> documents = result.docs;

    documents.forEach((snapshot) {
      if (snapshot.get('email') == email) {
        adminControl = true;
        setState(() {});
      }
    });
    return false;
  }

  Future<void>bitenToplantiyiAl(int index,streamSnapshot) async {

    Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};
   final QuerySnapshot result = await FirebaseFirestore.instance.collection('toplantilar').get();
   final List<DocumentSnapshot> documents =result.docs;

       eklenecekToplanti['baslik'] = documents[index]['baslik'];
       eklenecekToplanti['konu'] = documents[index]['konu'];
       eklenecekToplanti['mekan'] = documents[index]['mekan'];
       eklenecekToplanti['departman'] = documents[index]['departman'];
       eklenecekToplanti['tarihsaat'] =documents[index]['tarihsaat'];
       await firestore.collection('gecmistoplantilar').add(eklenecekToplanti);
       setState(() {});  

  }

  void BitenToplantiyiSil(int index, streamSnapshot) {
    FirebaseFirestore.instance
        .collection("toplantilar")
        .doc(streamSnapshot.data?.docs[index])
        .delete()
        .then((doc) => print("document deleted"),
            onError: (e) => print("error anam"));
  }
}
