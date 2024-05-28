import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tunisie_app/Screens/adminScreens/editservice.dart';

class DetailsService extends StatefulWidget {
  final String postid;
  final String imgLink;
  final String title;
  final String soustitre;
  final String description;
  const DetailsService(
      {super.key,
      required this.postid,
      required this.imgLink,
      required this.title,
      required this.soustitre,
      required this.description});

  @override
  State<DetailsService> createState() => _DetailsServiceState();
}

class _DetailsServiceState extends State<DetailsService> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Plus de details",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          userData['role'] == 'Admin'
              ? IconButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("services")
                        .doc(widget.postid)
                        .delete();
                    // ignore: use_build_context_synchronously
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const Bourses()));
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    CupertinoIcons.delete_simple,
                    color: Colors.red,
                  ))
              : Container(),
          const SizedBox(
            width: 5,
          ),
          userData['role'] == 'Admin'
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditService(
                                postid: widget.postid,
                                titre: widget.title,
                                soustitre: widget.soustitre,
                                description: widget.description)));
                  },
                  icon: const Icon(
                    // ignore: deprecated_member_use
                    Icons.edit,
                    color: Colors.green,
                  ))
              : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                // height: 205,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Row(children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Image.network(
                        widget.imgLink,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 90,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.soustitre,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.description,
                style: const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
