import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tunisie_app/Screens/agentScreens/details.dart';

class RendezVous extends StatefulWidget {
  const RendezVous({super.key});

  @override
  State<RendezVous> createState() => _RendezVousState();
}

class _RendezVousState extends State<RendezVous> {
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
          ):
    Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Liste des rendez-vous",
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
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
            child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('rendezVous').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
            return const  Text('Something went wrong');
                    }
            
                    if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(
                        child: LoadingAnimationWidget.discreteCircle(
                            size: 32,
                            color: const Color.fromARGB(255, 16, 16, 16),
                            secondRingColor: Colors.indigo,
                            thirdRingColor: Colors.pink.shade400),
                      );
                    }
            
                    return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsendezVous(
                                  nom: data['nom'],
                                  prenom: data['prenom'],
                                  date: data['date'],
                                  message: data['message'],
                                  email: data['email'],
                                  token: data['token'],
                                  id: data['uid'],
                                  status: data['status'],
                                  postid: data['post_id'],
                                )));
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/profilepic.svg',
                            height: 60.0,
                            width: 60.0,
                            allowDrawingOutsideViewBox: true,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['nom']
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    data['nom'].substring(1) +
                                    " " +
                                    data['prenom']
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    data['prenom'].substring(1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                data['date'],
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 14),
                              )
                            ],
                          ),
                          const Spacer(),
                          Text(
                            data['status'] == 'En attente'
                                ? 'En attente'
                                : data['status'] == 'Accepter'
                                    ? 'Accepter'
                                    : 'Refuser',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: data['status'] ==
                                        'En attente'
                                    ? Colors.blue
                                    : data['status'] == 'Accepter'
                                        ? Colors.green
                                        : Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
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
