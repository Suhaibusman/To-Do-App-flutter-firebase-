import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/screen/homepage.dart';
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
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  
  
// Future<UserCredential?> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//        // ignore: use_build_context_synchronously
//        Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage(userNames: '',)),
//         );
//       // Once signed in, return the UserCredential
//       return await FirebaseAuth.instance.signInWithCredential(credential);
      
//     } catch (e) {
//       // Handle any errors that may occur during sign-in
//       // ignore: avoid_print
//       print('Error signing in with Google: $e');
//       return null;
//     }
//   }

  
  Future<void> loginUser() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailAddress.text, password: password.text);

      if (userCredential.user != null) {
      // Fetch the user's data from Firestore based on their email
      final user = userCredential.user;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('emailAddress', isEqualTo: user!.email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data() as Map<String, dynamic>;
        final userName = userData['name'];

        // Navigate to the homepage and pass the user's name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userNames: userName),
          ),
        );
      }
    }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }

      // Show an error dialog with the error message.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Error"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }
  bool isPassVisible =true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
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
                 const TextWidget(textMessage: "Log in to Shh!", textColor: Colors.white, textSize: 40),
                      
                      const SizedBox(height: 40,),
                       InkWell(
                        onTap: () {
                        //  fireBaseFunctions.signInWithGoogle();
                        //  signInWithGoogle();
                        },
                        child: CustomButtonWidget(imageAddress: "assets/images/googlelogo.png", bgColor: Colors.black, textMessage: "Sign in with Google", textColor: Colors.white, textSize: 20, buttonWidth: MediaQuery.of(context).size.width*0.8,)),
                    const SizedBox(height: 40,),
                     Image.asset("assets/images/continuewithEmail.png"),
                      const SizedBox(height: 40,),
                         const Padding(
                           padding: EdgeInsets.only(left:50),
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               TextWidget(textMessage: "Username or Email", textColor: Colors.black, textSize: 15),
                             ],
                           ),
                         ),
                        const SizedBox(height: 10,),
                      CustomTextField(textFieldController: emailAddress,),
                         const SizedBox(height: 20,),
                         const Padding(
                           padding: EdgeInsets.only(left:50 , right: 50),
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               TextWidget(textMessage: "Password", textColor: Colors.black, textSize: 15),
                               TextWidget(textMessage: "Forgot", textColor: Colors.black, textSize: 15),
                             ],
                           ),
                         ),
                        const SizedBox(height: 10,),
                      CustomTextField(textFieldController: password, isPass: isPassVisible, textFieldIcon: IconButton(onPressed: (){
                    setState(() {
                      isPassVisible =!isPassVisible;
                    });
                   }, icon: const Icon(Icons.remove_red_eye_outlined))),
              const SizedBox(height: 20,),
            InkWell(
                    onTap: () {
                        loginUser();
                    },
                    child: CustomButtonWidget( bgColor: Colors.black, textMessage: "Login", textColor: Colors.white, textSize: 20, buttonWidth: MediaQuery.of(context).size.width*0.4,)),
              
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                           const TextWidget(textMessage: "Don’t have an account?", textColor: Colors.white, textSize: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const TextWidget(textMessage: "Sign up", textColor: Colors.black, textSize: 20),
    
                      ),
                       const SizedBox(height: 50,),
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



