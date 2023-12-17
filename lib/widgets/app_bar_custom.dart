import 'package:flutter/material.dart';

import '../configs/constants.dart';
import '../utils/resizable.dart';

class AppBarCustom extends AppBar {
  AppBarCustom(
    title,
    context, {
    key,
    actions = const <Widget>[],
    titleColor = Colors.black,
  }) : super(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: primaryColor),
          centerTitle: true,
          toolbarHeight: 80,
          actions: actions,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: Resizable.font(context, 19),
                    color: titleColor,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
}
