import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoapp/data/data.dart';
import 'package:todoapp/screen/homepage.dart';

class SignUpController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool loading = false.obs;
  RxBool isAgree = false.obs;
  RxBool isPassVisible = true.obs;
  signUpWithEmailAndPassword() async {
    loading.value = true;
    String emailAddress = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String userName = userNameController.text.toString().trim();

    if (emailAddress == "" || password == "" || userName == "") {
      Get.snackbar("Sign up Error", "Please Fill All The Values");
      loading.value = false;
    } else if (isAgree.isFalse) {
      loading.value = false;
      Get.snackbar("Sign up Error", "Please Agree Terms and Conditions");
    } else {
      try {
        loading.value = true;
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
          loading.value = false;
          Get.snackbar("Sign Up Successfully",
              "The User With This Email: $emailAddress is Registered Successfully");
          emailController.clear();
          passwordController.clear();
          userNameController.clear();
        }
      } on FirebaseAuthException catch (e) {
        loading.value = false;
        Get.snackbar("Error", e.toString());
      } catch (e) {
        loading.value = false;
        Get.snackbar("Error", e.toString());
      }
    }
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
