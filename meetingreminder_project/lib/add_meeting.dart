// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meetingreminder_project/custom_dialog.dart';
import 'package:meetingreminder_project/expired_meetings.dart';
import 'package:meetingreminder_project/reminder_page.dart';
import 'package:meetingreminder_project/viewModel.dart';

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



                }),
                child: Text('Ekle'))
          ],
        )));
  }

   veriEkle() async {
    if(secilenTarih.millisecondsSinceEpoch == DateTime.now().millisecondsSinceEpoch || secilenTarih.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch){
      Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};
      eklenecekToplanti['baslik'] = toplantiAdiController.text;
      eklenecekToplanti['konu'] = mySubjectController.text;
      eklenecekToplanti['mekan'] = toplantiYeriController.text;
      eklenecekToplanti['departman'] = toplantiDepartmanController.text;
      eklenecekToplanti['tarihsaat'] =
          DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih);
      await firestore.collection('expiredtoplanti').add(eklenecekToplanti);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Geçmiş Tarihli Kayıt İşleminiz Tamamlanmıştır."),
            content: new Text("Toplantıyı Geçmiş Toplantılar listesinde görebilirsiniz."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: new Text("Geçmiş Toplantılar Sayfasına Git"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExpiredPage()));
                },
              ),
              //TODO: admin yetkisi gelecek. --
              //TODO: tasarımlar değişecek,
              //TODO: geçen toplantılar biten toplantılar sayfasına eklenecek
              //TODO: toplantılar arasında sıralama yapılacak
              //TODO: taslak eklenecek
              //TODO: tarihi yaklaşanlar renk değiştirecek
              //TODO: localde katıldığım toplantılar falan tutulsun. SQFLite
              //TODO: sharedpref meselesini araştırcaz oturum açık kalsın diye falan
            ],
          );

        },
      );
    }

    else{


    Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};
    eklenecekToplanti['baslik'] = toplantiAdiController.text;
    eklenecekToplanti['konu'] = mySubjectController.text;
    eklenecekToplanti['mekan'] = toplantiYeriController.text;
    eklenecekToplanti['departman'] = toplantiDepartmanController.text;
    eklenecekToplanti['tarihsaat'] =
        DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih);
    await firestore.collection('toplantilar').add(eklenecekToplanti);
      await NotificationVM.bildirimGonder(toplantiAdiController.text, DateFormat("dd.MM.yyyy - HH:mm ").format(secilenTarih));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Kaydedildi."),
          content: new Text("Toplantıyı listede görebilirsiniz."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: new Text("Listeye Dön"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReminderPage()));
              },
            ),
            //TODO: admin yetkisi gelecek. --
            //TODO: tasarımlar değişecek,
            //TODO: geçen toplantılar biten toplantılar sayfasına eklenecek
            //TODO: toplantılar arasında sıralama yapılacak
            //TODO: taslak eklenecek
            //TODO: tarihi yaklaşanlar renk değiştirecek
            //TODO: localde katıldığım toplantılar falan tutulsun. SQFLite
            //TODO: sharedpref meselesini araştırcaz oturum açık kalsın diye falan
          ],
        );

      },
    );}
  }
}
