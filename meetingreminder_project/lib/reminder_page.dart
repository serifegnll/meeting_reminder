import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_meeting.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  var adminControll = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toplantılar"),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddMeetingPage()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
    body: StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('toplantilar')
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    return ListView.builder(
    itemCount: streamSnapshot.data?.docs.length,
        itemBuilder: (BuildContext context, int index) {
      return listItem(index, streamSnapshot);
    });}
   ),);


      /*Container(
          child: Column(
        children: [
          Container(child: Text("TOPLANTILAR")),
          Expanded(
            child: ListView.builder(
              itemCount: 8,

            ),
          ),
        ],
      )),
    );*/
  }

  Widget listItem(int index, streamSnapshot) {
    return Card(
      color: Colors.blueGrey[60],
      shadowColor: Colors.black54,
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
            height: 50,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(10),
            child: Text(
              "asdljkajsd".toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30)),
              color: Colors.black87,
            ),
          ),
          Container(
            child:
            Text(streamSnapshot.data?.docs[index]['konu']),
          ),
          Container(
            child: Text(streamSnapshot.data?.docs[index]['tarihsaat']),
          ),
          Container(
            child: Text(streamSnapshot.data?.docs[index]['mekan']),
          ),
          Container(
            child: Text(streamSnapshot.data?.docs[index]['departman']),
          ),
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
}
