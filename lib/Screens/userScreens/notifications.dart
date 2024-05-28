import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Notifications extends StatefulWidget {
  // final String uid;
  const Notifications({
    super.key,

// required this.uid
  });

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
      // print(e.toString());
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
              title: const Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
              ),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("notifications")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 32,
                  color: const Color.fromARGB(255, 16, 16, 16),
                  secondRingColor: Colors.indigo,
                  thirdRingColor: Colors.pink.shade400),
            );
                        }

                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // "Laamyr Aymane",
                                  data['nom'],
                                  style: const TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  // "Le contenue de ce rendez-vous est :  donne moi juste un petit example de ce que j'aime ",
                                  data['reponse'],
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/point.svg",
                                      height: 14,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      // "22/10/2022",
                                      DateFormat('yMMMd').format(
                                          data['reponse_date'].toDate()),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
