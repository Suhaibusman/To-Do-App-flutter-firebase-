import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/controller/login_controller.dart';
import 'package:todoapp/screen/signuppage.dart';
import 'package:todoapp/widgets/buttonwidget.dart';
import 'package:todoapp/widgets/textfieldwidget.dart';
import 'package:todoapp/widgets/textwidget.dart';

class LoginScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loginScreenImage.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextWidget(
                    textMessage: "Log in to Shh!",
                    textColor: Colors.white,
                    textSize: 40),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                    onTap: () {
                      //  fireBaseFunctions.signInWithGoogle();
                      //  signInWithGoogle();
                    },
                    child: CustomButtonWidget(
                      imageAddress: "assets/images/googlelogo.png",
                      bgColor: Colors.black,
                      textMessage: "Sign in with Google",
                      textColor: Colors.white,
                      textSize: 20,
                      buttonWidth: MediaQuery.of(context).size.width * 0.8,
                    )),
                const SizedBox(
                  height: 40,
                ),
                Image.asset("assets/images/continuewithEmail.png"),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget(
                          textMessage: "Username or Email",
                          textColor: Colors.black,
                          textSize: 15),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  textFieldController: loginController.emailController,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          textMessage: "Password",
                          textColor: Colors.black,
                          textSize: 15),
                      TextWidget(
                          textMessage: "Forgot",
                          textColor: Colors.black,
                          textSize: 15),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return CustomTextField(
                      textFieldController: loginController.passwordController,
                      isPass: loginController.isPassVisible.value,
                      textFieldIcon: IconButton(
                          onPressed: () {
                            loginController.isPassVisible.value =
                                !loginController.isPassVisible.value;
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined)));
                }),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return loginController.loading.value
                      ? const CircularProgressIndicator()
                      : InkWell(
                          onTap: () {
                            loginController.loginWithEmailAndPassword();
                          },
                          child: CustomButtonWidget(
                            bgColor: Colors.black,
                            textMessage: "Login",
                            textColor: Colors.white,
                            textSize: 20,
                            buttonWidth:
                                MediaQuery.of(context).size.width * 0.4,
                          ));
                }),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const TextWidget(
                              textMessage: "Don’t have an account?",
                              textColor: Colors.white,
                              textSize: 20),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const TextWidget(
                                textMessage: "Sign up",
                                textColor: Colors.black,
                                textSize: 20),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
