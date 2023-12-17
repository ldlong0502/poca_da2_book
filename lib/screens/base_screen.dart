import 'package:flutter/material.dart';
import 'package:poca/widgets/header_custom.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key, required this.child, required this.title});
  final Widget child;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50)
          , child: HeaderCustom(title: title,),)
      ),
      body: child,
    );
  }
}
