import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:poca/blocs/mini_player_cubit.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/utils/custom_toast.dart';

class PlayerRowControl extends StatelessWidget {
  const PlayerRowControl({super.key, required this.cubit});

  final PlayerCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, int>(
      bloc: cubit,
      builder: (context, state) {
        return Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    if(cubit.indexChapter - 1 < 0 ) {
                      CustomToast.showBottomToast(context, 'Bạn đang nghe chương đầu!');
                    }
                    else {
                      cubit.changeChapter(cubit.indexChapter - 1);
                    }
                  },
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    color: primaryColor,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    cubit.seekPrevious(const Duration(seconds: 30));
                  },
                  icon: Image.asset('assets/icons/ic_replay30.png',
                      color: primaryColor, height: 30)),
              CircleAvatar(
                radius: 45,
                backgroundColor: primaryColor.withOpacity(0.2),
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    child: IconButton(
                        onPressed: () {
                          if (cubit.isPlay && cubit.status == ProcessingState
                              .ready) {
                            cubit.pause();
                          }
                          else {
                            cubit.play();
                          }
                        },
                        icon: cubit.isLoading ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,

                          ),
                        ) :Icon(
                          cubit.isPlay &&
                              (cubit.status == ProcessingState.ready || cubit.status == ProcessingState.buffering) ? Icons
                              .pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ))),
              ),
              IconButton(
                  onPressed: () {
                    cubit.seekNext(const Duration(seconds: 30));
                  },
                  icon: Image.asset('assets/icons/ic_next30.png',
                      color: primaryColor, height: 30)),
              IconButton(
                  onPressed: () {
                   if(cubit.indexChapter + 1 > cubit.currentPodcast!.episodesList.length - 1) {
                     CustomToast.showBottomToast(context, 'You are listening final episodes');
                   }
                   else {
                     cubit.changeChapter(cubit.indexChapter + 1);
                   }
                  },
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    color: primaryColor,
                    size: 30,
                  )),
            ],
          ),
        );
      },
    );
  }
}
