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
        title: const Text("Geçmiş Toplantılar"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('gecmistoplantilar')
              .snapshots(),
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
              child: Column(children: [
                Text(
                  streamSnapshot.data?.docs[index]['baslik'].toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Text(
                    "lkdfhşls"
                  )
                ),
              ])),
        ]),
      ),
    );
  }
}

void toplantiBitti() {}
