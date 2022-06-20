import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetingreminder_project/add_meeting.dart';

class DraftPage extends StatefulWidget {
  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  final baslikController = new TextEditingController();
  final konuController = new TextEditingController();
  final tarihController = new TextEditingController();
  final mekanController = new TextEditingController();
  final departmanController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('drafts').snapshots(),
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
                InkWell(
                    child: Text(
                        streamSnapshot.data?.docs[index]['baslik']
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text("Taslağı Düzenle"),
                            content: new Text(
                                "Toplantıyı düzenlemeye devam etmek ister misiniz?"),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                child: new Text("Evet"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddMeetingPage()));
                                },
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                child: new Text("Hayır"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DraftPage()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    })
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
  taslakDuzenle(int index, streamSnapshot){
    baslikController.text= streamSnapshot.data?.docs[index]['baslik'];
    konuController.text= streamSnapshot.data?.docs[index]['konu'];
    mekanController.text= streamSnapshot.data?.docs[index]['mekan'];
    departmanController.text= streamSnapshot.data?.docs[index]['departman'];
   
  }
}
