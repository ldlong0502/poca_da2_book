import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/utils/resizable.dart';

class HeaderCustom extends StatelessWidget {
  const HeaderCustom({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: Resizable.padding(context, 20)
      ),
      child: Row(
        children: [
         title.isEmpty ? InkWell(
           onTap: () {
             Navigator.pop(context);
           },
           child: Icon(
             Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
             color: textColor,
           ),
         ) : Text(title, style: TextStyle(
            fontSize: Resizable.font(context, 30),
            color: textColor,
            fontWeight: FontWeight.bold
          ),),
          const Spacer(),


          BlocBuilder<UserCubit, UserModel?>(
            builder: (context, user) {
              if(user == null) return Container();
              return Row(
                children: [
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none_outlined, color: primaryColor, size: 40,),
                      Positioned(
                          top: 6,
                          right: 5,
                          child:  Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: Colors.white , shape: BoxShape.circle),
                              child: const Badge(smallSize: 10,)))
                    ],
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    height: Resizable.size(context, 40),
                    width: Resizable.size(context, 40),

                    decoration: BoxDecoration(
                        color: secondaryColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(user!.imageUrl),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                ],
              );
            }
          )

        ],
      ),
    );
  }
}
