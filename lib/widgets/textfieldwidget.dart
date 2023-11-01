import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textFieldController;
  final bool? isPass;
  final IconButton? textFieldIcon;
  final String? hintText;

  const CustomTextField({Key? key, required this.textFieldController, this.isPass, this.hintText, this.textFieldIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextField(
        controller: textFieldController,
        obscureText: isPass ?? false,
        decoration: InputDecoration(
          suffixIcon: textFieldIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
