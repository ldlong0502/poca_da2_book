import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/loading_progress.dart';

class DeletePlaylistDialog extends StatelessWidget {
  const DeletePlaylistDialog({super.key, required this.onDelete});
  final Function() onDelete;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Column(
          children: [
            Text('Are you sure?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Resizable.font(context, 20),
                  color: textColor,
                  fontWeight: FontWeight.w700
              ),),
            const SizedBox(height: 20,),
            Text('Do you want to delete this playlist?',
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
            TextButton(
                onPressed: onDelete,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20))
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Delete' , style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.white , fontSize: 18),)
                  ],
                )),
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Cancel' , style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.black , fontSize: 18),)
                  ],
                )),
          ],
        )
      ],
    );
  }
}
