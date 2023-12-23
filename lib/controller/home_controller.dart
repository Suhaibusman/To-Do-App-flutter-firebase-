import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/widgets/textfieldwidget.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController taskAddController = TextEditingController();
  TextEditingController taskUpdateController = TextEditingController();
  RxBool loading = false.obs;
  RxBool isOldPassVissible = true.obs;
  RxBool isNewPassVissible = true.obs;
  RxBool isconfirmNewPassVissible = true.obs;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  DateTime formattedDate = DateTime.now();
  String formatTime(DateTime formattedDate) {
    return DateFormat('h:mm a').format(formattedDate);
  }

  formatDate() {
    return "${formattedDate.day}/${formattedDate.month}/${formattedDate.year}";
  }

  void addTask() async {
    if (taskAddController.text.isNotEmpty) {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("tasks")
          .add({
        "task": taskAddController.text,
        "time": formatTime(DateTime.now()),
        "date": formatDate(),
        "isCompleted": false,
      });
      taskAddController.clear();

      Get.snackbar(
        "Success",
        "Task added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Please enter task",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void deleteTask(String docId) async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("tasks")
        .doc(docId)
        .delete();

    Get.snackbar("Deleted", "Task deleted successfully");
  }

  void updateTask({
    required String docId,
    required String task,
  }) async {
    taskUpdateController.text = task;
    Get.dialog(AlertDialog(
      title: const Text("Update Task"),
      content: CustomTextField(
        textFieldController: taskUpdateController,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await firestore
                .collection("users")
                .doc(auth.currentUser!.uid)
                .collection("tasks")
                .doc(docId)
                .update({
              "task": taskUpdateController.text,
              "time": formatTime(DateTime.now()),
              "date": formatDate(),
            });
            taskUpdateController.clear();
            Get.back();
          },
          child: const Center(child: Text("Update")),
        )
      ],
    ));
  }

  void changePassword() async {
    loading.value = true;
    String oldPass = oldPasswordController.text.toString().trim();
    String newPass = newPasswordController.text.toString().trim();
    String confirmNewPass = confirmNewPasswordController.text.toString().trim();

    if (oldPass == "" || newPass == "" || confirmNewPass == "") {
      Get.snackbar("Change Password Error", "Please Fill All The Values");
      loading.value = false;
    } else if (newPass != confirmNewPass) {
      Get.snackbar("Change Password Error",
          "New Password and Retype Password not match");
      loading.value = false;
    } else {
      final User? user = auth.currentUser;

      if (user != null) {
        try {
          loading.value = true;
          // Sign in the user with their current password for reauthentication
          final AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: oldPasswordController.text,
          );

          await user.reauthenticateWithCredential(credential);

          // Change the password
          await user.updatePassword(newPasswordController.text);
          loading.value = false;
          firestore.collection("users").doc(user.uid).update({
            "Password": newPasswordController.text,
          });
          // Clear the password fields
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmNewPasswordController.clear();

          Get.snackbar("Password Change", "Password changed successfully!");
        } catch (e) {
          loading.value = false;
          Get.snackbar("Error", "Error changing password: $e");
        }
      } else {
        loading.value = false;
        Get.snackbar("Error", "No user found");
      }
    }
  }
}
