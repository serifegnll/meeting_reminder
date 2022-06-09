const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(fuctions.config().firebase);

const db = admin.firestore();


exports.notification=functions.firestore.documents('admin/{UID}').onWrite(async{event,context}=>{
const fcmToken = event.after.data()['fcm'];
const title = event.after.data()['title'];
const content= event.after.data()['content'];
console.log(fcmToken);
var message ={
notification:{
title:title,
body:content,
},
"data":{
click_action:"FLUTTER_NOTIFICATION_CLICK",
sound:"default",
},
token:fcmToken,
}
let response =await admin.messaging().send(message);

console.log(response);
});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
