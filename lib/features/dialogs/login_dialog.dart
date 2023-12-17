import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/loading_progress.dart';

class LoginErrorDialog extends StatelessWidget {
  const LoginErrorDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Column(
          children: [
            Text('Incorrect \nusername or password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Resizable.font(context, 20),
                color: textColor,
                fontWeight: FontWeight.w700
            ),),
            const SizedBox(height: 20,),
            Text('The username or password you entered doesn\'t appear to belong to an account. Please check your username or password and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Resizable.font(context, 14),
                  color: secondaryColor,
                  fontWeight: FontWeight.w600
              ),),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 20)
      ).copyWith(top: 0),
      actions: [
        Column(
          children: [
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Try Again' , style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.black , fontSize: 20),)
                  ],
                )),
          ],
        )
      ],
    );
  }
}
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title:  Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Resizable.padding(context, 30)
          ),
          child:const LoadingProgress(),
        ),
      ),
    );
  }
}