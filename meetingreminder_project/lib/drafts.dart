import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meetingreminder_project/add_meeting.dart';
import 'package:intl/intl.dart';
import 'package:meetingreminder_project/taslakVeriler.dart';

class DraftPage extends StatefulWidget {
  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  List<TextEditingController> controllers = [];
  bool _isEditingText = false;
  DateTime secilenTarih = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    Veriler yenitaslak = taslakVeriGetir(index, streamSnapshot);

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
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: SizedBox(
                    height: 30,
                    width: 200,
                    child: TextField(
                      enabled: _isEditingText,
                      controller: controllers[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        controllers[0].text = val;
                        yenitaslak.baslik = controllers[0].text;
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Visibility(
                      visible: _isEditingText,
                      child: SizedBox(
                          child: IconButton(
                              icon: Icon(
                                Icons.save_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                taslakKaydet(index, streamSnapshot, yenitaslak);
                                _isEditingText=false;
                              })),
                    ))
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
                        height: MediaQuery.of(context).size.height * 0.02,
                        child: TextFormField(
                          enabled: _isEditingText,
                          controller: controllers[1],
                          onChanged: (val) {
                            controllers[1].text = val;
                            yenitaslak.konu = controllers[1].text;
                          },
                        ),
                      )
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
                      height: MediaQuery.of(context).size.height * 0.02,
                      child: TextField(
                        enabled: _isEditingText,
                        controller: controllers[2],
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2010, 3, 5, 0, 0),
                              maxTime: DateTime(2100, 6, 6, 0, 0),
                              onConfirm: (val) {
                            secilenTarih = val;
                            controllers[2].text =
                                DateFormat('dd.MM.yyyy – kk:mm')
                                    .format(secilenTarih)
                                    .toString();
                            setState(() {
                              yenitaslak.zaman = controllers[2].text;
                            });

                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.tr);
                        },
                      ),
                    ),
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
                        height: MediaQuery.of(context).size.height * 0.02,
                        child: TextField(
                          enabled: _isEditingText,
                          controller: controllers[3],
                          textAlign: TextAlign.left,
                          onChanged: (val) {
                            controllers[3].text = val;
                            yenitaslak.mekan = controllers[3].text;
                          },
                        )),
                  ])),
              const Divider(
                height: 0,
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
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.02,
                        child: TextField(
                          enabled: _isEditingText,
                          controller: controllers[4],
                          textAlign: TextAlign.left,
                          onChanged: (val) {
                            controllers[4].text = val;
                            yenitaslak.departman = controllers[4].text;
                          },
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: IconButton(
                          alignment: Alignment.bottomRight,
                          icon: Icon(
                            Icons.draw,
                            size: 30,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_isEditingText == false) {
                                _isEditingText = true;
                              } else {
                                _isEditingText = false;
                              }
                            });
                          }),
                    ),
                  ])),
            ]),
          ])),
        ]),
      ),
    );
  }

  Veriler taslakVeriGetir(int index, streamSnapshot) {
    // Veriler(streamSnapshot.data?.docs[index]['baslik'],streamSnapshot.data?.docs[index]['konu'],streamSnapshot.data?.docs[index]['mekan'],streamSnapshot.data?.docs[index]['tarihsaat'],streamSnapshot.data?.docs[index]['departman'] );
    Veriler taslak = Veriler();
    taslak.VerilerEkle(
        streamSnapshot.data?.docs[index]['baslik'],
        streamSnapshot.data?.docs[index]['konu'],
        streamSnapshot.data?.docs[index]['mekan'],
        streamSnapshot.data?.docs[index]['tarihsaat'],
        streamSnapshot.data?.docs[index]['departman'],
        streamSnapshot.data?.docs[index].reference.id);
    controllers = controllerOlustur(taslak);
    controllers[0].text = taslak.baslik;
    controllers[1].text = taslak.konu;
    controllers[3].text = taslak.mekan;
    controllers[2].text = taslak.zaman;
    controllers[4].text = taslak.departman;
    return taslak;
  }

  void taslakKaydet(int index, streamSnapshot, Veriler doc) async {
    var collection = FirebaseFirestore.instance.collection('drafts');
    collection.doc(doc.id).update({'baslik': doc.baslik});
    collection.doc(doc.id).update({'konu': doc.konu});
    collection.doc(doc.id).update({'mekan': doc.mekan});
    collection.doc(doc.id).update({'tarihsaat': doc.zaman});
    collection.doc(doc.id).update({'departman': doc.departman});
  }

  List<TextEditingController> controllerOlustur(Veriler veri) {
    TextEditingController baslikController = TextEditingController();
    TextEditingController konuController = TextEditingController();
    TextEditingController tarihController = TextEditingController();
    TextEditingController mekanController = TextEditingController();
    TextEditingController departmanController = TextEditingController();
    List<TextEditingController> controllerList = [
      baslikController,
      konuController,
      tarihController,
      mekanController,
      departmanController
    ];
    return controllerList;
  }
}
