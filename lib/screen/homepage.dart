// ignore_for_file: avoid_print


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/screen/loginpage.dart';
import 'package:todoapp/widgets/textfieldwidget.dart';

class HomePage extends StatefulWidget {
  final String? userNames;
  const HomePage({Key? key,  this.userNames}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userId = "users/id";
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  TextEditingController emailAddress =TextEditingController();
   TextEditingController password =TextEditingController();
   TextEditingController name =TextEditingController();
   TextEditingController userName =TextEditingController();
Future<void> addTask(String userId) async {
  final userDocRef = FirebaseFirestore.instance.collection("users").doc(userId);

  // Check if the user document exists
  final userDocSnapshot = await userDocRef.get();

  if (userDocSnapshot.exists) {
    // The user document exists, so you can add a task to the "todos" collection.
    final todosCollection = userDocRef.collection("todos");

    // Create a map with the to-do item data
    final taskData = {
      "name": 
      "name.text",
      "password": "password.text",
      "userName": "userName.text",
      "emailAddress": "emailAddress.text"
      ,
    };

    // Add the to-do item to the "todos" collection
    todosCollection.add(taskData).then((value) {
      print("To-do item added for user: $userId");
    }).catchError((error) {
      print("Error adding to-do item: $error");
    });
  } else {
    print("User document with ID $userId does not exist.");
  }
}

void updateUsernameAndPass(DocumentSnapshot doc) {
  final nameController = TextEditingController(text: doc['name']);
  final emailAddressController = TextEditingController(text: doc['emailAddress']);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Update"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text("Name:"),
                Expanded(child: CustomTextField(textFieldController: nameController)),
              ],
            ),
            Row(
              children: [
                const Text("Email:"),
                Expanded(child: CustomTextField(textFieldController: emailAddressController)),
              ],
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Update the document in Firestore
              FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                'name': nameController.text,
                'emailAddress': emailAddressController.text,
                // Update other fields as well
              }).then((value) {
                print("Document updated");
                Navigator.pop(context); // Close the dialog
              }).catchError((error) {
                print("Error updating document: $error");
              });
              setState(() {});
            },
            child: const Text("Update"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
    
            Text(widget.userNames ??"unknown"),
            TextButton(
              onPressed: () {
                // Implement your image pick logic here
              },
              child: const Text("Pick Image"),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: const Text("Sign out"),
            ),
            StreamBuilder(
              stream: usersStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(doc['name']),
                          subtitle: Text(doc['emailAddress']),
                        trailing:  Row(
                         mainAxisSize: MainAxisSize.min,
                          children: [
                             IconButton(onPressed: (){
                              name.text=doc['name'];
                               emailAddress.text=doc['emailAddress'];
                            updateUsernameAndPass(doc);
                             }, icon: const Icon(Icons.edit)),
                            IconButton(onPressed: (){
                               FirebaseFirestore.instance.collection('users').doc(doc.id).delete().then((value) => ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
      content: Text("${doc['name']} deleted Successfully"),
      duration: const Duration(seconds: 2), // Adjust the duration as needed
      ),
    ));
                            }, icon: const Icon(Icons.delete)),
                            
                          ],
                        ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Text("No data available");
                }
              },
            ),
            FloatingActionButton(onPressed: (){
              addTask(userId);
            }, child: const Icon(Icons.add),)
          ],
        ),
      ),
    );
  }
}
