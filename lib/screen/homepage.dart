import 'package:cloud_firestore/cloud_firestore.dart';
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

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final String userNames;
  HomeController homeController = Get.put(HomeController());
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomePage({Key? key, required this.userNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primaryColor, primaryLightColor])),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: white,
                      child: TextWidget(
                          textMessage: userNames[0].toUpperCase(),
                          textColor: primaryColor,
                          textSize: 20),
                    ),
                    TextWidget(
                        textMessage: userNames.toUpperCase(),
                        textColor: white,
                        textSize: 20),
                    TextWidget(
                        textMessage: homeController.auth.currentUser!.email!,
                        textColor: Colors.black,
                        textSize: 10),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const TextWidget(
                    textMessage: "Home", textColor: Colors.black, textSize: 15),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const TextWidget(
                    textMessage: "Change Password",
                    textColor: Colors.black,
                    textSize: 15),
                onTap: () {
                  Get.back();
                  Get.defaultDialog(
                      title: "Change Password",
                      content: box.read("loginwithemail") == true
                          ? Column(
                              children: [
                                CustomTextField(
                                  textFieldController:
                                      homeController.oldPasswordController,
                                  hintText: "Enter Old Password",
                                  isPass: true,
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                CustomTextField(
                                  textFieldController:
                                      homeController.newPasswordController,
                                  hintText: "Enter new Password",
                                  isPass: true,
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                CustomTextField(
                                  textFieldController: homeController
                                      .confirmNewPasswordController,
                                  hintText: "Enter Confirm Password",
                                  isPass: true,
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                InkWell(
                                  onTap: () {
                                    homeController.changePassword();
                                  },
                                  child: CustomButtonWidget(
                                    textMessage: "Change",
                                    bgColor: primaryColor,
                                    textColor: white,
                                    textSize: 15,
                                    buttonWidth: Get.width * 0.5,
                                  ),
                                )
                              ],
                            )
                          : const Center(
                              child: TextWidget(
                                  textMessage:
                                      "You Can't Change Password Because You are Login With Google",
                                  textColor: Colors.black,
                                  textSize: 15),
                            ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const TextWidget(
                    textMessage: "Logout",
                    textColor: Colors.black,
                    textSize: 15),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  box.remove("currentLoginUsername");
                  box.remove("isLogined");
                  box.read("loginwithemail");
                  box.erase();
                  Get.offAll(const SplashScreen());
                },
              ),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryColor, primaryLightColor])),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: white,
                        size: 30,
                      )),
                  Center(
                      child: TextWidget(
                          textMessage: "WELLCOME ${userNames.toUpperCase()}",
                          textColor: white,
                          textSize: 20)),
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
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
                      bgColor: primaryColor,
                      textColor: white,
                      textSize: 15,
                      buttonWidth: Get.width * 0.2,
                    ),
                  )
                ],
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: homeController.firestore
                    .collection("users")
                    .doc(homeController.auth.currentUser!.uid)
                    .collection("tasks")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>> taskSnapshot =
                        snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        taskDocuments = taskSnapshot.docs;

                    if (taskDocuments.isEmpty) {
                      return const Center(child: Text("No Tasks Found"));
                    } else {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        itemCount: taskDocuments.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> taskData =
                              taskDocuments[index].data();

                          return ListTile(
                            title: TextWidget(
                                textMessage: taskData['task'],
                                textColor: white,
                                textSize: 12),
                            subtitle: TextWidget(
                                textMessage:
                                    "Date: ${taskData['date']}\nTime: ${taskData['time']}",
                                textColor: Colors.black,
                                textSize: 12),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: white,
                                  ),
                                  onPressed: () {
                                    homeController.updateTask(
                                      docId: taskDocuments[index].id,
                                      task: taskData['task'],
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: white,
                                  ),
                                  onPressed: () {
                                    homeController
                                        .deleteTask(taskDocuments[index].id);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return const Center(child: Text("No Data Found"));
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
