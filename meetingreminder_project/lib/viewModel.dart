import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationVM {
  static bildirimGonder(toplantiAdi, toplantiSaati) async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    await  http.post( Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAS0FZ8NE:APA91bF_VLMREMzVecxnyyMvmD0SmDydlpp-8RVDBtQlKOBZs2Ghq28JWJfT8Io4FnVR-R__O0iJK7jkud7FXR0fzAl_0nFgU6K_CCDXkq_i8Fg1xRBENV1hQHQ7IqTi-7rXGZUS1nmL'
        },
        body: jsonEncode({
          'notification': <String, dynamic>{
            'title': toplantiAdi,
            'body': toplantiSaati,
            'sound': 'true'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to":"/topics/TopicToListen"
        })).whenComplete(() {


    }).catchError((e) {

    });
  }



}

