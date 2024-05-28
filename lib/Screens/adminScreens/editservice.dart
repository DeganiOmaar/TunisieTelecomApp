import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tunisie_app/shared/addtextfield.dart';
import 'package:tunisie_app/shared/profilebutton.dart';

// ignore: must_be_immutable
class EditService extends StatelessWidget {
  final String postid;
  final String titre;
  final String soustitre;
  final String description;
  EditService(
      {super.key,
      required this.postid,
      required this.titre,
       required this.soustitre,
      required this.description,
      });

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController titreController = TextEditingController();

  TextEditingController soustitreController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
    centerTitle: true,
           title: const Text(
          "Mettre a jour un service",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
          ),
          body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: formstate,
        child: Column(
          children: [
            const Gap(20),
            AddAvisTField(
              title: 'titre',
              text: titre,
              controller: titreController,
              validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },
            ),
            const Gap(10),
            AddAvisTField(
              title: 'Soustitre',
              text: soustitre,
              controller: soustitreController,
              validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },
            ),
            const Gap(10),
            AddAvisTField(
              title: 'Description',
              text: description,
              controller: descriptionController,
              validator: (value) {
                return value!.isEmpty ? "ne peut être vide" : null;
              },
            ),
            
            const Gap(20),
            Row(
              children: [
                Expanded(
                    child: ProfileButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('services')
                              .doc(postid)
                              .update({
                            "titre": titreController.text == ""
                                ? titre
                                : titreController.text,
                            "duree":
                                soustitreController.text == ""
                                    ? soustitre
                                    : soustitreController.text,
                            "description": descriptionController.text == ""
                                ? description
                                : descriptionController.text,
                            
                          });
                          // if(!mounted) return;
                           // ignore: use_build_context_synchronously
                           QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Bourse mis à jour avec succes!',
                              onConfirmBtnTap: () {
                                titreController.clear();
                                soustitreController.clear();
                                descriptionController.clear();
                                Navigator.of(context).pop();
                              });
                        },
                        textButton: "Mettre à jour le Service")),
              ],
            ),
          ],
        ),
      ),
    ),
          ),
        );
  }
}