import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tunisie_app/Screens/userscreens.dart';
import 'package:tunisie_app/firebase_options.dart';
import 'package:tunisie_app/registerScreens/login.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
 
class MyApp extends StatefulWidget {
    myrequestForPerrmission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("============================================");
    print(mytoken);
  }

  sendMessage({required String title, required String message}) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization':
          'AAAA_v2Iu4c:APA91bE3fzCuUt5Nr1BSHzbJoHDo9iDBFZAASOHegmZ8_1kFKIH-qME23Yof5AY_6NlHnCllhnj6CIjNEVCUPesD-y24owe_lnclQJMlkpj10UxsJECP0EWe4pEf5lYKgctHnDu1GwWx'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": "token from firebase",
      "notification": {
        "title": title,
        "body": message,
        "mutable_content": true,
        "sound": "Tri-tone"
      }
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? const Login()
          : const UserScreen(),
    );
  }
}