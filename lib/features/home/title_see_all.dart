import 'package:flutter/material.dart';

import '../../configs/constants.dart';
import '../../utils/resizable.dart';

class TitleSeeAll extends StatelessWidget {
  const TitleSeeAll({super.key, required this.title, required this.onSeeAll});
  final String title;
  final Function() onSeeAll;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(
              fontSize: Resizable.font(context, 24),
              color: textColor,
              fontWeight: FontWeight.w600
          ),),
          InkWell(
            onTap: onSeeAll,
            child: Text('See All', style: TextStyle(
                fontSize: Resizable.font(context, 18),
                color: textColor,
                fontWeight: FontWeight.w600
            ),),
          ),

        ],
      ),
    );
  }
}
