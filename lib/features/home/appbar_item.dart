import 'package:flutter/material.dart';

import '../../utils/resizable.dart';

class AppBarItem extends StatelessWidget {
  const AppBarItem({super.key, required this.asset, required this.height, required this.title, required this.onTap});
  final String asset;
  final String title;
  final double height;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000)
            ),
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(asset, height: Resizable.size(context, height),),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(title , style: TextStyle(
            color: Colors.white,
            fontSize: Resizable.font(context, 13)
        ),),
      ],
    );
  }
}
