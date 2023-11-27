import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/screen/homepage.dart';

import '../data/data.dart';

class LoginController extends GetxController {
  RxBool loading = false.obs;
   TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  loginWithEmailAndPassword() async {
    loading.value = true;
    String emailAddress = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (emailAddress == "" || password == "") {
      Get.snackbar("Error", "Please Fill All The Values");
      loading.value = false;
    } else {
   loading.value  = true; 
      try {
        loading.value = true;
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        emailController.clear();
        passwordController.clear();
        if (credential.user != null) {
          loading.value=false;
          currentLoginUid = box.write("key", credential.user!.uid);
          Get.until((route) => route.isFirst);
          Get.to(const HomePage());
        }
      } on FirebaseAuthException catch (e) {
        loading.value = false;
        Get.snackbar("Error", e.code.toString());
      }
    }
  }
}
