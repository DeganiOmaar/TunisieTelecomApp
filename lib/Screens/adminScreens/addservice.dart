import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart' show basename;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tunisie_app/shared/addtextfield.dart';
import 'package:uuid/uuid.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController titreController = TextEditingController();
  TextEditingController dureeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();



  File? imgPath;
  String? imgName;
  bool isLoading = false;
  uploadImage2Screen() async {
    final XFile? pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (pickedImg != null) {
        imgPath = File(pickedImg.path);
        setState(() {
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        // print("NO img selected");
      }
    } catch (e) {
      // print("Error => $e");
    }
  }

  ajouterUnService() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref("$imgName");
      await storageRef.putFile(imgPath!);
      String urll = await storageRef.getDownloadURL();

      CollectionReference course =
          FirebaseFirestore.instance.collection('services');
      String newId = const Uuid().v1();
      course.doc(newId).set({
        'service_id' : newId,
        "imgLink": urll == "" ? "assets/images/service.png" : urll,
        "titre": titreController.text,
        "duree": dureeController.text,
        "description": descriptionController.text,
      });
    } catch (err) {
      if(!mounted) return;
        // showSnackBar(context, "ERROR :  $err ");
    }
    setState(() {
      isLoading = false;
    });
  }

    afficherAlert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Services ajouter avec succes!',
        onConfirmBtnTap: () {
          titreController.clear();
          dureeController.clear();
          descriptionController.clear();
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
    centerTitle: true,
    title: const Text(
      "Ajouter un Service",
      style: TextStyle(
          fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700),
    ),
          ),
          body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: formstate,
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  imgPath == null
                      ? const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 225, 225, 225),
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/images/service.png"),
                        )
                      : ClipOval(
                          child: Image.file(
                            imgPath!,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    left: 65,
                    bottom: -10,
                    child: IconButton(
                      onPressed: () {
                        uploadImage2Screen();
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 19,
                      ),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
                const Gap(10),
            AddAvisTField(
                title: 'Titre',
                text: 'Ajouter un titre',
                controller: titreController, 
                  validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },),
            const Gap(10),
            AddAvisTField(
                title: 'Sous-titre',
                text: 'Ajouter un sous-titre',
                controller: dureeController, 
                  validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },),
            const Gap(10),
            AddAvisTField(
                title: 'Description',
                text: 'Ajouter une description',
                controller: descriptionController, 
                  validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },),
            const Gap(40),

            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          
    
                              if (formstate.currentState!.validate()) {
                      await ajouterUnService();
                          // if (!mounted) return;
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const Bourses()));
                          afficherAlert();
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Erreur',
                              text: 'Ajouter Les informations necessaires', 
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.indigo),
                          padding: isLoading
                              ? MaterialStateProperty.all(
                                  const EdgeInsets.all(9))
                              : MaterialStateProperty.all(
                                  const EdgeInsets.all(12)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        child: isLoading
                            ? Center(
                                child:
                                    LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 32,
                                ),
                              )
                            : const Text(
                                "Ajouter une Service",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ))),
              ],
            ),
            const Gap(10),
          ],
        ),
      ),
    ),
          ),
        );
  }
}