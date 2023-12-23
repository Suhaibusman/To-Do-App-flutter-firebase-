import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
          box.write("loginwithemail", true);

          // Navigate to HomeScreen
          Get.offAll(() => HomePage(
                userNames: box.read("currentloginedName"),
              ));
          box.write("isLogined", true);
          isLogined = true;
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

  Future<UserCredential> signInWithGoogle() async {
    try {
      loading.value = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Access the user details
      final user = userCredential.user;

      if (user != null) {
        loading.value = false;

        // Check if user already exists in Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          // User already exists, retrieve existing data
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          box.write("currentloginedName", userData["username"]);
          box.write("currentLoginedPhoneNumber", userData["phoneNumber"]);
          box.write("address", userData["address"]);

          Get.offAll(() => HomePage(
                userNames: box.read("currentloginedName"),
              ));
          box.write("isLogined", true);
        } else {
          // User does not exist, store additional user information in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'username': user.displayName,
            'emailAddress': user.email,
          });
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      Get.snackbar("Error", e.toString());
      rethrow;
    } catch (e) {
      loading.value = false;
      Get.snackbar("Error", e.toString());
      rethrow;
    }
  }
}
