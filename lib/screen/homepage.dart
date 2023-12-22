import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/controller/home_controller.dart';
import 'package:todoapp/data/constant.dart';
import 'package:todoapp/data/data.dart';
import 'package:todoapp/screen/splashscreen.dart';
import 'package:todoapp/widgets/buttonwidget.dart';
import 'package:todoapp/widgets/textfieldwidget.dart';
import 'package:todoapp/widgets/textwidget.dart';

class HomePage extends StatelessWidget {
  final String userNames;
  const HomePage({Key? key, required this.userNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
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
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 30,
                      )),
                  Center(
                      child: TextWidget(
                          textMessage: "WELLCOME ${userNames.toUpperCase()}",
                          textColor: Colors.black,
                          textSize: 20)),
                ],
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  box.remove("currentLoginUsername");
                  box.remove("isLogined");
                  // currentLoginUid = box.remove("currentLoginUid");

                  Get.offAll(const SplashScreen());
                },
                child: const Text("Sign out"),
              ),
              Row(
                children: [
                  CustomTextField(
                    textFieldController: homeController.taskAddController,
                  ),
                  InkWell(
                    onTap: () {
                      homeController.addTask();
                    },
                    child: CustomButtonWidget(
                      textMessage: "Add",
                      bgColor: primaryLightColor,
                      textColor: white,
                      textSize: 15,
                      buttonWidth: Get.width * 0.2,
                    ),
                  )
                ],
              ),
              Expanded(
                  child: StreamBuilder(
                stream: homeController.firestore
                    .collection("users")
                    .doc(homeController.auth.currentUser!.uid)
                    .collection("tasks")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: primaryLightColor,
                            title: Text(snapshot.data!.docs[index]["task"]),
                            subtitle: Text(snapshot.data!.docs[index]["time"]),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
