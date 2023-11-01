import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String textMessage;
  final Color textColor;
  final double textSize;
  final int? textHeight;
  const TextWidget({super.key, required this.textMessage, required this.textColor, required this.textSize, this.textHeight});

  @override
  Widget build(BuildContext context) {
    return Text(textMessage ,maxLines: textHeight, style: TextStyle(
      color: textColor,
      fontSize: textSize,
      fontWeight: FontWeight.bold,
      
      
  
    ),);
  }
}