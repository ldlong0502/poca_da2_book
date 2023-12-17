import 'package:flutter/material.dart';

import '../configs/constants.dart';
import '../utils/resizable.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color backgroundColor;
  final Color textColor;
  final double height, fontSize, width;
  final FontWeight fontWeight;
  final bool border;
  final double radius;
  const CustomButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.backgroundColor,
      required this.textColor,
      this.height = 45,
      this.width = 200,
      this.radius = 15,
      this.fontSize = 20,
      this.fontWeight = FontWeight.w500,
      this.border = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Resizable.size(context, 90)),
          border: Border.all(
              width: 1, color: border ? primaryColor : Colors.transparent)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return primaryColor.withOpacity(0.8);
              }
              return backgroundColor;
            }),
            elevation: MaterialStateProperty.all(5),
            minimumSize: MaterialStateProperty.all( Size(width , height)),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              vertical: Resizable.padding(context, 15),
            )),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius)))),
        child: Text(title,
            maxLines: 1,
            style: TextStyle(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: Resizable.size(context, fontSize))),
      ),
    );
  }
}
