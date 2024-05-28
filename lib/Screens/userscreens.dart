// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tunisie_app/Screens/adminScreens/services.dart';
import 'package:tunisie_app/Screens/adminScreens/users.dart';
import 'package:tunisie_app/Screens/agentScreens/rendezvous.dart';
import 'package:tunisie_app/Screens/userScreens/allrendezvous.dart';
import 'package:tunisie_app/profile.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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

  final PageController _pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 32,
                  color: Colors.black,
                  secondRingColor: Colors.indigo,
                  thirdRingColor: Colors.pink.shade400),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Padding(
              padding:
                  const EdgeInsets.only(left: 4.0, right: 4, top: 4, bottom: 4),
              child: GNav(
                gap: 8,
                color: Colors.grey,
                activeColor: Colors.indigo,
                curve: Curves.decelerate,
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 2),
                onTabChange: (index) {
                  _pageController.jumpToPage(index);
                  setState(() {
                    currentPage = index;
                  });
                },
                tabs: [
               GButton(
                    icon: Icons.home_outlined,
                    text:  'Services',
                  ),
                   GButton(
                    icon: userData['role'] == 'Admin' ? LineAwesomeIcons.user_astronaut_solid : userData['role'] == "Utilisateur"? Icons.all_out : Icons.all_out,
                    text:  userData['role'] == 'Admin' ?'Utilisateurs' : 'Rendez-vous',
                  ),
                  GButton(
                    icon: CupertinoIcons.person,
                    text: 'Profile',
                  ),
                ],
              ),
            ),
            body: PageView(
              onPageChanged: (index) {},
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Services(),
                userData['role'] == 'Admin' ? UsersPage() : userData['role'] == "Utilisateur"? AllRendezVous() : RendezVous(),
                Profile()
              ],
            ),
          );
  }
}
