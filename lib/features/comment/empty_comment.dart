import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/utils/resizable.dart';

class EmptyComment extends StatelessWidget {
  const EmptyComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Resizable.padding(context, 20),
      ),
      padding: EdgeInsets.symmetric(
        vertical: Resizable.padding(context, 20),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white70
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/icons/ic_chat_empty.png', height: 70,),
          Text('Chưa có đánh giá nào' , style: TextStyle(
            color: purpleColor,
            fontWeight: FontWeight.bold,
            fontSize: Resizable.font(context, 13),
          ),)
        ],
      ),
    );
  }
}
