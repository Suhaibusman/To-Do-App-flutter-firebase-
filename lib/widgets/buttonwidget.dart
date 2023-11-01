import 'package:flutter/material.dart';
import 'package:todoapp/widgets/textwidget.dart';

class CustomButtonWidget extends StatelessWidget {
  final Color bgColor;
  final double buttonWidth;
  final String? imageAddress; 
   final String textMessage;
  final Color textColor;
  final double textSize;
  final int? textHeight;
  const CustomButtonWidget({super.key, required this.bgColor, this.imageAddress, required this.textMessage, required this.textColor, required this.textSize, this.textHeight, required this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: bgColor
      ),
      height: 60,
      width: buttonWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           if (imageAddress != null) // Check if imageAddress is not null
            Image.asset(imageAddress! , height: 25,),
            const SizedBox(width: 10,), // Show the image if provided
          TextWidget(textMessage: textMessage, textColor: textColor, textSize: textSize)
        ],
      ),
    );
  }
}