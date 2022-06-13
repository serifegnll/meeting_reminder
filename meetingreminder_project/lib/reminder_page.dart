import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
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
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 200,
        child: Column(children: [
          Container(
            height: 60,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  //buraya kalan zamanı yazcaz
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        child: Row(children: [
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.3,
                            child: Text('Toplantı Konusu: ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.6,
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: Row(children: [
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.3,
                            child: Text('Toplantı Zamanı: ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.6,
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: Row(children: [
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.3,
                            child: Text('Toplantı Mekanı: ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.6,
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: Row(children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.3,
                          child: Text('Departman: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.6,
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
    final QuerySnapshot result = await FirebaseFirestore.instance.collection(
        'admins').get();
    final List <DocumentSnapshot> documents = result.docs;

    documents.forEach((snapshot) {
      if (snapshot.get('email') == email) {
        adminControl = true;
        setState(() {

        });
      }
    }
    );
    return false;
  }

}