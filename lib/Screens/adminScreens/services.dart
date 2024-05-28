import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tunisie_app/Screens/adminScreens/addservice.dart';
import 'package:tunisie_app/Screens/adminScreens/details.dart';
import 'package:tunisie_app/shared/servicecard.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
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
              title: const Text(
                "Notre Services",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              centerTitle: true,
              leading: userData['role'] == 'Admin'
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddService()));
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    )
                  : const SizedBox(),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('services')
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
                            return ServiceCard(
                                imgLink: data['imgLink'],
                                title: data['titre'],
                                time: data['duree'],
                                description: data['description'],
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsService(
                                              postid: data['service_id'],
                                              imgLink: data['imgLink'],
                                              title: data['titre'],
                                              soustitre: data['duree'],
                                              description: data['description'])));
                                });
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
  }
}
