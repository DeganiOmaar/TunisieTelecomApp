// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tunisie_app/Screens/userscreens.dart';
import 'package:tunisie_app/shared/customtField.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String? selectedRole; // Default selected role is 'User'
  bool isFocused = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  register() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "fullname": nameController.text,
        "CIN":"",
        "emplacement" : "",
        "role": selectedRole,
        "email": emailController.text,
        "password": passwordController.text,
        "phone": phoneController.text,
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UserScreen()));
    } 
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error...',
          text: 'week pass!',
        );
      } else if (e.code == 'email-already-in-use') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error...',
          text: 'Email used!',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Check your informations please!',
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    phoneController.clear();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SvgPicture.asset("assets/images/register.svg",
              height: 170,
              ),
               const SizedBox(
                height: 60,
              ),
              CustomTfield(
                isPassword: false,
                text: 'Full Name',
                icon: Icons.person_2_outlined,
                myController: nameController,
                validator: (value) {
                  return value!.isEmpty ? "Enter a valid Name" : null;
                },
              ),
              const SizedBox(height: 10,),
             Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                    color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Center(
                    child: DropdownButton<String>(
                      value: selectedRole,
                      icon: const Icon(Icons.arrow_downward,color: Colors.black87,),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                      onChanged: (newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                      hint: const Text('ajouter un role ',style: TextStyle(color: Colors.black87,),),
                      underline: Container(),
                      items: <String>['Utilisateur', 'Agent','Admin' ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTfield(
                isPassword: false,
                text: 'Email',
                icon: Icons.email_outlined,
                myController: emailController,
                validator: (email) {
                  return email!.contains(RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                      ? null
                      : "Enter a valid email";
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTfield(
                isPassword: true,
                text: 'Password',
                icon: Icons.visibility_off_outlined,
                myController: passwordController,
                validator: (value) {
                  return value!.isEmpty
                      ? "Enter at least 6 characters"
                      : null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              IntlPhoneField(
                controller: phoneController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black87),
                  ),
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: Colors.black87),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black38),
                  ),
                ),
                initialCountryCode: 'TN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formstate.currentState!.validate()) {
                      await register();
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Error',
                        text: 'Add your informations',
                      );
                    }
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                  child: isLoading
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 30,
                        )
                      : const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              
            
            ],
          ),
        ),
      ),
    );
  }
}
