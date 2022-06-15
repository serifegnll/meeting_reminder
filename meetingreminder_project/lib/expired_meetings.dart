import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:timeago/timeago.dart';

class ExpiredPage extends StatefulWidget {
  @override
  _ExpiredPageState createState() => _ExpiredPageState();
}

@override
class _ExpiredPageState extends State<ExpiredPage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toplantılar"),

      ),
      body: StreamBuilder(
          stream:
          FirebaseFirestore.instance.collection('expiredtoplanti').snapshots(),
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
                    streamSnapshot.data?.docs[index]['baslik'].toUpperCase(),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)
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
}

void toplantiBitti() {}
