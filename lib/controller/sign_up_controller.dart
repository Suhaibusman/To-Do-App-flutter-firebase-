import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  TextEditingController emailController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController userNameController= TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool loading = false.obs;
  signUpWithEmailAndPassword(
      ) async {
    String emailAddress = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String userName = userNameController.text.toString().trim();

    if (emailAddress == "" || password == "" || userName == "") {
      Get.snackbar( "Sign up Error", "Please Fill All The Values");
    } else {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        await firestore.collection("users").doc(credential.user!.uid).set({
          "username": userName,
          "emailAddress": emailAddress,
          "Password": password
        });
        if (credential.user != null) {
          Get.snackbar( "Sign Up Successfully",
              "The User With This Email: $emailAddress is Registered Successfully");
          emailController.clear();
          passwordController.clear();
          userNameController.clear();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar( "Sign Up Error", "The Password is To Weak");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar( "Sign Up Error",
              "The account already exists for that email");
        }
      } catch (e) {
        Get.snackbar( "Error", e.toString());
      }
    }
  }


}