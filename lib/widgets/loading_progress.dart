import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../configs/constants.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key,  this.color = primaryColor}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return   Center(
      child: SizedBox(
          child: SpinKitCircle(
            color: color,
            size: 50.0,
            duration: const Duration(seconds: 1),
          )),
    );
  }
}