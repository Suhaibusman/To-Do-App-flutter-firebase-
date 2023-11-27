import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/data/data.dart';
import 'package:todoapp/screen/homepage.dart';
import 'package:todoapp/screen/loginpage.dart';

class FireBaseFunctions{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // TextEditingController passController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  Future customDialogBox(
    context,
    String title,
    String message,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
   signUpWithEmailAndPassword(
      context, emailController, passwordController, userNameController) async {
    String emailAddress = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String userName = userNameController.text.toString().trim();

    if (emailAddress == "" || password == "" || userName == "") {
      customDialogBox(context, "Sign up Error", "Please Fill All The Values");
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
          customDialogBox(context, "Sign Up Successfully",
              "The User With This Email: $emailAddress is Registered Successfully");
          emailController.clear();
          passwordController.clear();
          userNameController.clear();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          customDialogBox(context, "Sign Up Error", "The Password is To Weak");
        } else if (e.code == 'email-already-in-use') {
          customDialogBox(context, "Sign Up Error",
              "The account already exists for that email");
        }
      } catch (e) {
        customDialogBox(context, "Error", e.toString());
      }
    }
  }

  loginWithEmailAndPassword(
      context, emailController, passwordController) async {
    String emailAddress = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if (emailAddress == "" || password == "") {
      customDialogBox(context, "Error", "Please Fill All The Values");
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        emailController.clear();
        passwordController.clear();
        if (credential.user != null) {
          // currentloginedUsername = credential.user!.uid;
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>  HomePage( userNames:  currentLoginedName ?? box.read("currentloginedName"),),
              ));
        }
      } on FirebaseAuthException catch (e) {
        customDialogBox(context, "Error", e.code.toString());
      }
    }
  }

  signout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  LoginScreen(),
        ));
  }

}