import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class DetailsendezVous extends StatefulWidget {
  final String nom;
  final String prenom;
  final String date;
  final String message;
  final String email;
  final String token;
  final String status;
  final String id;
  final String postid;
  const DetailsendezVous(
      {super.key,
      required this.nom,
      required this.prenom,
      required this.date,
      required this.message,
      required this.email,
      required this.token,
      required this.status,
      required this.id,
      required this.postid});

  @override
  State<DetailsendezVous> createState() => _DetailsendezVousState();
}

class _DetailsendezVousState extends State<DetailsendezVous> {
  Map userData = {};
  bool isLoading = true;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = snapshot.data()!;
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  sendAcceptNotif() async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA_v2Iu4c:APA91bE3fzCuUt5Nr1BSHzbJoHDo9iDBFZAASOHegmZ8_1kFKIH-qME23Yof5AY_6NlHnCllhnj6CIjNEVCUPesD-y24owe_lnclQJMlkpj10UxsJECP0EWe4pEf5lYKgctHnDu1GwWx'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": widget.token,
      "notification": {
        "title": userData["fullname"],
        "body": "Votre rendez-vous a été accepté",
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

  sendRefusNotif() async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA_v2Iu4c:APA91bE3fzCuUt5Nr1BSHzbJoHDo9iDBFZAASOHegmZ8_1kFKIH-qME23Yof5AY_6NlHnCllhnj6CIjNEVCUPesD-y24owe_lnclQJMlkpj10UxsJECP0EWe4pEf5lYKgctHnDu1GwWx'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": widget.token,
      "notification": {
        "title": userData["fullname"],
        "body": "Votre rendez-vous a été reporté",
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

  ajouterNotifAcceptBD() async {
    String newNotifId = const Uuid().v1();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id).collection("notifications").doc(newNotifId)
        .set({
      'notifId': newNotifId,
      'nom': userData["fullname"],
      'reponse': "Votre rendez-vous a été accepté",
      'reponse_date': DateTime.now(),
      'token': widget.token,
      'reponseId': widget.id,
      // 'reponseUserId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  ajouterNotifRefusBD() async {
    String newNotifId = const Uuid().v1();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id).collection("notifications").doc(newNotifId)
        .set({
      'notifId': newNotifId,
      'nom': userData["fullname"],
      'reponse': "Votre rendez-vous a été reporté",
      'reponse_date': DateTime.now(),
      'token': widget.token,
      'reponseId': widget.id,
      // 'reponseUserId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.status == "En attente"
              ? IconButton(
                  onPressed: () async{
                    sendAcceptNotif();
                    ajouterNotifAcceptBD();
                    await FirebaseFirestore.instance
                        .collection('rendezVous')
                        .doc(widget.postid)
                        .update({
                      'status': "Accepter"
                    });
                    // if (!mounted) return;
                    // Navigator.of(context).pop();

                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.check, color: Colors.green),
                )
              : Container(),
          widget.status == "En attente"
              ? IconButton(
                  onPressed: () async {
                    sendRefusNotif();
                    ajouterNotifRefusBD();
                    await FirebaseFirestore.instance
                        .collection('rendezVous')
                        .doc(widget.postid)
                        .update({
                      'status': "Refuser"
                    });
                    // if (!mounted) return;
                    // Navigator.of(context).pop();

                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                )
              : Container(),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Details du rendez-vous",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            SvgPicture.asset(
              'assets/images/profilepic.svg',
              height: 75.0,
              width: 75.0,
              allowDrawingOutsideViewBox: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${widget.nom} ${widget.prenom}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.email,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.date,
              style: const TextStyle(color: Colors.black45, fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.message,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 14,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
