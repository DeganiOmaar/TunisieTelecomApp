import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tunisie_app/Screens/userScreens/addrendezvous.dart';
import 'package:tunisie_app/Screens/userScreens/notifications.dart';

class AllRendezVous extends StatefulWidget {
  const AllRendezVous({super.key});

  @override
  State<AllRendezVous> createState() => _AllRendezVousState();
}

class _AllRendezVousState extends State<AllRendezVous> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
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
              leading: IconButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddRendezVous()));
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Notifications()));
                  },
                  icon: const Icon(Icons.notifications_outlined),
                )
              ],
              centerTitle: true,
              title: const Text(
                "Tous les rendez-vous",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rendezVous')
                      .where("uid", isEqualTo:FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.discreteCircle(
                            size: 32,
                            color: const Color.fromARGB(255, 16, 16, 16),
                            secondRingColor: Colors.indigo,
                            thirdRingColor: Colors.pink.shade400),
                      );
                    }

                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(
                                      'https://cdn-icons-png.flaticon.com/512/147/147144.png'),
                                ),
                                const SizedBox(width: 10),
                                Column(
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
                                      // data['nom'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // "10 AM : 22/10/2024",
                                        data['date'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        data['message'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                data['status'] == 'En attente'
                                    ? Column(
                                        children: [
                                          data['uid'] == userData['uid']
                                              ? IconButton(
                                                  onPressed: () {
                                                    messageController.text = data[
                                                        'message']; // Pre-fill the TextField with existing avis
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Retour",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('rendezVous')
                                                                            .doc(data['post_id'])
                                                                            .update({
                                                                          'message': messageController.text == ""
                                                                              ? data['message']
                                                                              : messageController.text
                                                                        });
                                                                        messageController
                                                                            .clear();
                                                                        if (!mounted)
                                                                          return;
                                                                        Navigator.of(context)
                                                                            .pop();

                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Modifier",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.indigo),
                                                                      ))
                                                                ],
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                content:
                                                                    SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.9, // <-- TextField width
                                                                  height:
                                                                      180, // <-- TextField height
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        messageController,
                                                                    maxLines:
                                                                        null,
                                                                    expands:
                                                                        true,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      // filled: true,
                                                                      fillColor:
                                                                          Colors
                                                                              .black38,
                                                                      // hintText: data[
                                                                      //     'avis'],
                                                                      hintStyle:
                                                                          const TextStyle(
                                                                              color: Colors.black87),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              220,
                                                                              220,
                                                                              220),
                                                                        ),
                                                                      ),
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              220,
                                                                              220,
                                                                              220),
                                                                        ),
                                                                      ),
                                                                      contentPadding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              15,
                                                                          vertical:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                )));
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.green,
                                                  ))
                                              : Container(),
                                          data['uid'] == userData['uid']
                                              ? IconButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            "rendezVous")
                                                        .doc(data['post_id'])
                                                        .delete();
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  ))
                                              : Container(),
                                        ],
                                      )
                                    : data['status'] == 'Accepter'
                                        ? const Text("accepté",
                                            style:
                                                TextStyle(color: Colors.green, fontWeight: FontWeight.w600))
                                        : const Text(" refuse",
                                            style:
                                                TextStyle(color: Colors.red, fontWeight: FontWeight.w600), ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
