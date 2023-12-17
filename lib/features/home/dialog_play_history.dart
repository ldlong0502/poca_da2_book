import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/resizable.dart';

class DialogPlayHistory extends StatelessWidget {
  const DialogPlayHistory({super.key, required this.onPlayAgain, required this.onPlayContinue, required this.historyPodcast});
  final Function() onPlayAgain;
  final Function() onPlayContinue;
  final HistoryPodcast historyPodcast;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Center(
        child: Column(
          children: [
            Text('Please choose selection', style: TextStyle(
              fontSize: Resizable.font(context, 20),
              color: textColor,
              fontWeight: FontWeight.w700
            ),),
            const SizedBox(height: 20,),
            Text('You want to play this episode with name ${historyPodcast.podcast.episodesList[historyPodcast.indexChapter].title} of the podcast ${historyPodcast.podcast.title}',
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
            Row(
              children: [
                Expanded(
                  child: TextButton(onPressed: onPlayAgain,
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(const BorderSide(color: primaryColor))
                      ),
                      child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Play again' , style: TextStyle(fontWeight: FontWeight.w600),)
                    ],
                  )),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: TextButton(onPressed: onPlayContinue,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all( primaryColor)
                      ),
                      child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Play continue' , style: TextStyle(fontWeight: FontWeight.w600 ,color: Colors.white),)
                    ],
                  )),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
