// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meetingreminder_project/custom_dialog.dart';

class AddMeetingPage extends StatefulWidget {
  const AddMeetingPage({Key? key}) : super(key: key);

  @override
  State<AddMeetingPage> createState() => AddMeetingPageState();
}

class AddMeetingPageState extends State<AddMeetingPage> {
  final toplantiYeriController = TextEditingController();
  final mySubjectController = TextEditingController();
  final toplantiDepartmanController = TextEditingController();
  final toplantiAdiController = TextEditingController();
  final fcmToken = FirebaseMessaging.instance.getToken();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  getToken(){
    _firebaseMessaging.getToken().then((value){
      print(value);
    });
  }

  TextEditingController dateinput = TextEditingController();
  DateTime secilenTarih = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
        appBar: AppBar(title: Text('Toplantı Ekle')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              //********tOPLANTI ADI*/
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                    controller: toplantiAdiController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),),
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 2.0),),
                        labelText: 'Toplantı Adı',
                        hintText:
                        'Toplantının başlığın giriniz'))),
            SizedBox(height: 10),
            Padding(
                //******TOPLANTIYI DUZENLEYEN */
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                    controller: toplantiYeriController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),),
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 2.0),),
                        labelText: 'Toplantı Yeri',
                        hintText: 'Toplantı Yerini Giriniz'))),
            SizedBox(height: 10),
            Padding(
                //********tOPLANTI KONUSU */
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                    controller: mySubjectController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),),
                        focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 2.0),),
                        labelText: 'Konu',
                        hintText:
                            'Toplantı konusu hakkında kısa bir bilgi veriniz'))),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Padding(
                //******TOPLANTIYI MUHATAPLARI */
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                    controller: toplantiDepartmanController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),),
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 2.0),),
                        labelText: 'Departman',
                        hintText: 'Toplantıya gelecek departmanı giriniz'))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2010, 3, 5, 0, 0),
                        maxTime: DateTime(2100, 6, 6, 0, 0), onConfirm: (val) {
                      secilenTarih = val;
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.tr);
                  },
                  child: Text(DateFormat('dd.MM.yyyy – kk:mm')
                      .format(secilenTarih)
                      .toString())),
            ),
            SizedBox(height: 8),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  setState(() {});
                },
                child: Column(
                  children: [
                    Text(toplantiAdiController.text),
                    Text(toplantiYeriController.text),
                    Text(mySubjectController.text),
                    Text(DateFormat('dd.MM.yyyy – kk:mm')
                        .format(secilenTarih)
                        .toString()),
                  ],
                )),
            SizedBox(height: 10),

            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: (() async {
                  await veriEkle();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: new Text("Başarıyla Kaydedilmiştir."),
                        content: new Text("Alert Dialog body"),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );

                    },
                  );

                }),
                child: Text('Ekle'))
          ],
        )));
  }

   veriEkle() async {
    Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};
    eklenecekToplanti['baslik'] = toplantiAdiController.text;
    eklenecekToplanti['konu'] = mySubjectController.text;
    eklenecekToplanti['mekan'] = toplantiYeriController.text;
    eklenecekToplanti['departman'] = toplantiDepartmanController.text;
    eklenecekToplanti['tarihsaat'] =
        DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih);
    await firestore.collection('toplantilar').add(eklenecekToplanti);
  }
}
