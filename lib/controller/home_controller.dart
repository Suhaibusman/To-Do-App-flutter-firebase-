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
}
