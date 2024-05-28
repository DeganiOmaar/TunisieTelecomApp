import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tunisie_app/shared/profilebutton.dart';
import 'package:tunisie_app/shared/profiletfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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

  DateTime startDate = DateTime.now();
  bool isPicking = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController cinController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController emplacementController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor:  Colors.white,
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 32,
                  color: const Color.fromARGB(255, 16, 16, 16),
                  secondRingColor: Colors.indigo,
                  thirdRingColor: Colors.pink.shade400),
            ),
          )
        : Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
            Navigator.of(context).pop();
            },
            icon: const Icon(LineAwesomeIcons.angle_left_solid),
          ),
          title: const Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SvgPicture.asset(
                'assets/images/profilepic.svg',
                height: 120.0,
                width: 120.0,
                allowDrawingOutsideViewBox: true,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                      child: ProfileTextField(
                    title: "Nom",
                    text: 
                    // "Laamyr",
                    userData['nom'] == ""
                        ? "Entrer votre nom"
                        : userData['fullname'].substring(0, 1).toUpperCase() +
                            userData['fullname'].substring(1),
                    controller: fullNameController,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ProfileTextField(
                    title: "CIN",
                    text: 
                    // "Diallo",
                    userData['CIN'] == ""
                        ? "Entrer votre CIN"
                        : userData['CIN'],
                    controller: cinController,
                  )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: ProfileTextField(
                    title: "Email",
                    text: 
                    // "LaamyrDiallo@gmail.com",
                    userData['email'] == ""
                        ? "Entrer votre email"
                        : userData['email'],
                    controller: emailController,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ProfileTextField(
                    title: "Adress",
                    text: "Tunis",
                    // userData['adress'] == ""
                    //     ? "Entrer votre adress"
                    //     : userData['adress'],
                    controller: adressController,
                  )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
             
              Row(
                children: [
                  Expanded(
                      child: ProfileTextField(
                    title: "Emplacement",
                    text: 
                    // "Sfax, tunisie",
                    userData['emplacement'] == ""
                        ? "Entrer votre emplacement"
                        : userData['emplacement'],
                    controller: emplacementController,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ProfileTextField(
                    title: "Téléphone",
                    text:
                    "+216 " + userData['phone'],
                    controller: telephoneController,
                  )),
                ],
              ),
              const Spacer(),
                            Row(
                children: [
                  Expanded(
                      child: ProfileButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "fullname": fullNameController.text == ""
                                  ? userData['fullname']
                                  : fullNameController.text,
                              "CIN": cinController.text == ""
                                  ? userData['CIN']
                                  : cinController.text,
                              "email": emailController.text == ""
                                  ? userData['email']
                                  : emailController.text,
                              "emplacement": emplacementController.text == ""
                                  ? userData['emplacement']
                                  : adressController.text,
                              "phone": telephoneController.text == ""
                                  ? userData['phone']
                                  : telephoneController.text,
                             
                            });
                            setState(() {});
                    Navigator.of(context).pop();
                          },
                          textButton: "Mettre à jour votre profil")),
                ],
              ),
             const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
                  );
  }
}