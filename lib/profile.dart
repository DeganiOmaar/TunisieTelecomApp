import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tunisie_app/editprofile.dart';
import 'package:tunisie_app/registerScreens/login.dart';
import 'package:tunisie_app/shared/profilecard.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          )
        : Scaffold(
                     appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Profile",
              style:
                  TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            backgroundColor: Colors.white,
          ),
        
            body: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
              ),
              child: Column(children: [
                const SizedBox(
                  height: 50,
                ),
                SvgPicture.asset(
                  'assets/images/profilepic.svg',
                  height: 120.0,
                  width: 120.0,
                  allowDrawingOutsideViewBox: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userData['fullname'].substring(0, 1).toUpperCase() +
                      userData['fullname'].substring(1) + " ",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 17),
                ),
                Text(
                  userData['email'],
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(

                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (conetxt)=> const EditProfile()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Modifier Votre Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                ProfileCard(
                  text: "Paramétres",
                  icon: LineAwesomeIcons.cog_solid,
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                ProfileCard(
                  text: "Obtenir de l'aide",
                  icon: LineAwesomeIcons.question_circle,
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                ProfileCard(
                  text: "À propos de nous",
                  icon: LineAwesomeIcons.info_solid,
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 10,
                ),

                ProfileCard(
                  text: "Supprimer le compte",
                  icon: LineAwesomeIcons.trash_alt,
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const Login()),
                        (route) => false);
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: const Icon(
                      LineAwesomeIcons.sign_out_alt_solid,
                      color: Colors.red,
                    ),
                  ),
                  title: const Text(
                    "Déconnecter",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.red),
                  ),
                  trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Icon(
                      LineAwesomeIcons.angle_right_solid,
                      color: Colors.black45,
                      size: 18,
                    ),
                  ),
                ),
              ]),
            ),
          );
  }
}