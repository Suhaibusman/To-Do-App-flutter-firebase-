

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/screen/loginpage.dart';
import 'package:todoapp/screen/signuppage.dart';
import 'package:todoapp/widgets/buttonwidget.dart';
import 'package:todoapp/widgets/textwidget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
           decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/homeScreenImage.png"),
            fit: BoxFit.cover,
          ),
    
          ),
        child:  Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(textMessage: "Welcome To", textColor: Colors.white, textSize: 40),
                    TextWidget(textMessage: "Shh!", textColor: Colors.white, textSize: 40),
                    SizedBox(height : 20),
                    TextWidget(textMessage: "A Hub Where Whispers Echo Loudest", textColor: Colors.black, textSize: 20 , textHeight: 2,)
                  
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.45,
              ),
            
              SizedBox(child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:  (context) => const SignUpScreen(),));
                    },
                    child: CustomButtonWidget( bgColor: Colors.black, textMessage: "Sign up", textColor: Colors.white, textSize: 20, buttonWidth: MediaQuery.of(context).size.width*0.7,)),
                const SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextWidget(textMessage: "Already Have an Account?", textColor: Colors.white, textSize: 15),
                InkWell(
                  onTap: (){
             Get.to(LoginScreen(),);
                  },
                  child: const TextWidget(textMessage: "Login", textColor: Colors.black, textSize: 15)),
              ],
            )
                ],
              ))
           
            ],
          ),
        ),

        ),
      ),
    );
  }
}