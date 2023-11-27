// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/controller/sign_up_controller.dart';
import 'package:todoapp/screen/loginpage.dart';
import 'package:todoapp/widgets/buttonwidget.dart';
import 'package:todoapp/widgets/textfieldwidget.dart';
import 'package:todoapp/widgets/textwidget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isAgree = false;
  bool isPassVisible = true;
  @override
  Widget build(BuildContext context) {
    SignUpController signUpController = Get.put(SignUpController());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/signupscreenImage.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextWidget(
                        textMessage: "Sign up to Shh!",
                        textColor: Colors.white,
                        textSize: 40),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButtonWidget(
                      imageAddress: "assets/images/googlelogo.png",
                      bgColor: Colors.black,
                      textMessage: "Sign up with Google",
                      textColor: Colors.white,
                      textSize: 20,
                      buttonWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset("assets/images/continuewithEmail.png"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        textFieldController:
                            signUpController.userNameController,
                        hintText: "Enter Your Username"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        textFieldController: signUpController.emailController,
                        hintText: "Enter Email"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        textFieldController:
                            signUpController.passwordController,
                        hintText: "Enter Password",
                        isPass: isPassVisible,
                        textFieldIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPassVisible = !isPassVisible;
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye_outlined))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isAgree,
                          onChanged: (value) {
                            setState(() {
                              isAgree = !isAgree;
                            });
                          },
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: const TextWidget(
                                textMessage:
                                    "I agree with the Terms of Service and Privacy policy",
                                textColor: Colors.white,
                                textSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Obx(() {

                          return signUpController.loading.value ? const CircularProgressIndicator(): InkWell(
                              onTap: () {
                                signUpController.signUpWithEmailAndPassword();
                              },
                              child: CustomButtonWidget(
                                bgColor: Colors.black,
                                textMessage: "Create Account",
                                textColor: Colors.white,
                                textSize: 20,
                                buttonWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                              ));
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        const TextWidget(
                            textMessage: "Already have an account?",
                            textColor: Colors.white,
                            textSize: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                          },
                          child: const TextWidget(
                              textMessage: "Login",
                              textColor: Colors.black,
                              textSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
