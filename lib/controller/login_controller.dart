import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/screen/homepage.dart';

import '../data/data.dart';

class LoginController extends GetxController {
  bool isLogined = false;
  RxBool loading = false.obs;
  RxBool isPassVisible = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  loginWithEmailAndPassword() async {
    loading.value = true;
    String emailAddress = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if (emailAddress == "" || password == "") {
      Get.snackbar("Error", "Please Enter Username and Password");
      loading.value = false;
    } else {
      try {
        loading.value = true;
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        emailController.clear();
        passwordController.clear();

        box.write("currentloginedUid", credential.user!.uid);
        final userUid = credential.user!.uid;

        // Check if the user exists in the "user" collection
        DocumentSnapshot userSnapshot =
            await firestore.collection("users").doc(userUid).get();
        if (userSnapshot.exists) {
          // User is a regular user
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          box.write("currentloginedName", userData["username"]);

          // Navigate to HomeScreen
          Get.offAll(() => HomePage(
                userNames: box.read("currentloginedName") ?? "",
              ));
          box.write("isLogined", true);
          isLogined = true;
          //   Navigator.popUntil(context, (route) => route.isFirst);

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HomePage(
          // userNames: currentLoginedName ?? box.read("currentloginedName"),
          // )
          //   ),
          // );
        } else {
          Get.snackbar("Login Error", "You are not a registered user");
          // Handle the case where the user is not found in the "user" collection
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          e.toString(),
        );
      }
    }
    loading.value = false;
  }
}
