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
    RxBool isAgree = false.obs;
  RxBool isPassVisible = true.obs;
  signUpWithEmailAndPassword(
      ) async {
        loading.value =true;
    String emailAddress = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String userName = userNameController.text.toString().trim();

    if (emailAddress == "" || password == "" || userName == "") {
      Get.snackbar( "Sign up Error", "Please Fill All The Values");
     loading.value = false;
    } else if(isAgree.isFalse){
      loading.value = false;
       Get.snackbar( "Sign up Error", "Please Agree Terms and Conditions");
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
          Get.snackbar( "Sign Up Successfully",
              "The User With This Email: $emailAddress is Registered Successfully");
          emailController.clear();
          passwordController.clear();
          userNameController.clear();
        }
      } on FirebaseAuthException catch (e) {
    loading.value = false;
        Get.snackbar( "Error", e.toString());
      } catch (e) {
        loading.value = false;
        Get.snackbar( "Error", e.toString());
      }
    }
  }



//  final userId = "users/id";
//   final Stream<QuerySnapshot> usersStream =
//       FirebaseFirestore.instance.collection('users').snapshots();
//   TextEditingController emailAddress =TextEditingController();
//    TextEditingController password =TextEditingController();
//    TextEditingController name =TextEditingController();
//    TextEditingController userName =TextEditingController();
// Future<void> addTask(String userId) async {
//   final userDocRef = FirebaseFirestore.instance.collection("users").doc(box.read("currentLoginUid"));

//   // Check if the user document exists
//   final userDocSnapshot = await userDocRef.get();

//   if (userDocSnapshot.exists) {
//     // The user document exists, so you can add a task to the "todos" collection.
//     final todosCollection = userDocRef.collection("todos");

//     // Create a map with the to-do item data
//     final taskData = {
//       "name": 
//       "name.text",
//       "password": "password.text",
//       "userName": "userName.text",
//       "emailAddress": "emailAddress.text"
//       ,
//     };

//     // Add the to-do item to the "todos" collection
//     todosCollection.add(taskData).then((value) {
//       print("To-do item added for user: $userId");
//     }).catchError((error) {
//       print("Error adding to-do item: $error");
//     });
//   } else {
//     print("User document with ID $userId does not exist.");
//   }
// }

// void updateUsernameAndPass(DocumentSnapshot doc) {
//   final nameController = TextEditingController(text: doc['name']);
//   final emailAddressController = TextEditingController(text: doc['emailAddress']);
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text("Update"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 const Text("Name:"),
//                 Expanded(child: CustomTextField(textFieldController: nameController)),
//               ],
//             ),
//             Row(
//               children: [
//                 const Text("Email:"),
//                 Expanded(child: CustomTextField(textFieldController: emailAddressController)),
//               ],
//             )
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               // Update the document in Firestore
//               FirebaseFirestore.instance.collection('users').doc(doc.id).update({
//                 'name': nameController.text,
//                 'emailAddress': emailAddressController.text,
//                 // Update other fields as well
//               }).then((value) {
//                 print("Document updated");
//                 Navigator.pop(context); // Close the dialog
//               }).catchError((error) {
//                 print("Error updating document: $error");
//               });
            
//             },
//             child: const Text("Update"),
//           ),
//         ],
//       );
//     },
//   );
// }


}