import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/data/data.dart';
import 'package:todoapp/screen/loginpage.dart';
import 'package:todoapp/widgets/textwidget.dart';

class HomePage extends StatelessWidget {
  final String userNames;
  const HomePage({Key? key, required this.userNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
           height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loginScreenImage.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
            Row(
              children: [
                IconButton(onPressed: (){}, icon: const Icon( Icons.menu, color: Colors.black, size: 30,)),
                Center(child: TextWidget(textMessage: "WELLCOME ${userNames.toUpperCase()}" , textColor: Colors.black, textSize: 20)),
              ],
            ),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  box.remove("currentLoginUsername");
                  currentLoginUid = box.remove("currentLoginUid");
              
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: const Text("Sign out"),
              ),
                  // Expanded(
                  //           // height: MediaQuery.of(context).size.height * 0.8,
                  //           child: ListView.builder(itemCount: 100,itemBuilder: (context, index) {
                  //             return Padding(
                  //               padding: const EdgeInsets.all(10),
                  //               child: Container(
                  //                 height: 50,
                  //                color: Colors.blue,
                  //               ),
                  //             );
                  //           }),
                  //         ),
              
            ],
          ),
        ),
      ),
    );
  }
}
