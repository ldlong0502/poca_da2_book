import 'package:flutter/material.dart';

import '../../configs/constants.dart';
import '../../utils/resizable.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
        'Sorry, this topic is empty',
        style: TextStyle(
            fontSize: Resizable.font(context, 22),
            color: textColor,
            fontWeight: FontWeight.w600),),
          Image.asset('assets/icons/empty-box.png', height: Resizable.size(context, 100),)
        ],
      ),
    );
  }
}
