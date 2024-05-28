// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tunisie_app/shared/customtextfield.dart';
import 'package:uuid/uuid.dart';

class AddRendezVous extends StatefulWidget {
  
  const AddRendezVous({super.key});

  @override
  State<AddRendezVous> createState() => _AddRendezVousState();
}

class _AddRendezVousState extends State<AddRendezVous> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
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

       getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("============================================");
    // print(mytoken);
    return mytoken;
  }
   ajouterRendezVous() async {
    String myNotifToken = await getToken();
    setState(() {
      isLoading = true;
    });

    try {
      CollectionReference course =
          FirebaseFirestore.instance.collection('rendezVous');
      String newId = const Uuid().v1();
      course.doc(newId).set({
        'post_id' : newId,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        "token": myNotifToken,
        'nom': nameController.text,
        'prenom': prenomController.text,
        'email': emailController.text,
        'date': dateController.text,
        'message': messageController.text, 
        'status': "En attente",
        
      });
    } catch (err) {}
    setState(() {
      isLoading = false;
    });
  }

       afficherAlert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Rendez-vous ajouter avec succes!',
        onConfirmBtnTap: () {
          nameController.clear();
          prenomController.clear();
          emailController.clear();
          dateController.clear();
          messageController.clear();
          Navigator.of(context).pop();
        });
  }
  @override
  void initState() {
    // _searchController.addListener(_onSearchChanged);
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 32,
                  color: const Color.fromARGB(255, 16, 16, 16),
                  secondRingColor: Colors.indigo,
                  thirdRingColor: Colors.pink.shade400),
            ),
          ):  Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
                    appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Ajouter Rendez-vous",
              style:
                  TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            backgroundColor: Colors.white,
         
          ),
          body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: SingleChildScrollView(
      child: Stack(
        children: [
          SvgPicture.asset(
        'assets/images/typing.svg',
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height * 0.9,
      ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Bienvenue dans notre espace",
                style: TextStyle(
                    fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
               CustomTextField(text: "Ajuter votre nom", controller: nameController,),
              const SizedBox(
                height: 20,
              ),
               CustomTextField(text: "Ajuter votre Prénom", controller: prenomController,),
              const SizedBox(
                height: 20,
              ),
               CustomTextField(text: "Ajouter votre email", controller: emailController,),
              const SizedBox(
                height: 20,
              ),
               CustomTextField(text: "Ajouter la date du rendez-vous", controller: dateController,),
              const SizedBox(
                height: 20,
              ),
            
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.9, // <-- TextField width
                height: 180, // <-- TextField height
                child: TextField(
                  controller: messageController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: "Ajouter votre message",
                    hintStyle: const TextStyle(color: Colors.black26),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 220, 220, 220),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 220, 220, 220),
                      ),
                    ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    alignLabelWithHint: true, // Ensure hint text stays aligned with content
                  ),
                ),
              )
          ,
          // const Spacer(),
          const SizedBox(height: 150,),
          Center(
            child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async{
                    await ajouterRendezVous();
                      afficherAlert();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
          ),
           const SizedBox(height: 50,), 
            ],
          ),
        ],
      ),
    ),
          ),
        );
  }
}