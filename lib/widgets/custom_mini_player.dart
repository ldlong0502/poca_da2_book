import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:poca/blocs/mini_player_cubit.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/audio_book/max_player_audio_book.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/players/max_player_podcast.dart';
import 'package:poca/features/players/min_player_podcast.dart';

import '../features/audio_book/mini_player_audio_book.dart';
import '../utils/resizable.dart';

class CustomMiniPlayer extends StatelessWidget {
  const CustomMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, int>(
      builder: (cc, state) {
        final playerCubit = cc.read<PlayerCubit>();
        return playerCubit.currentPodcast == null ? Container() : AnimatedPositioned(
          bottom: playerCubit.isMiniPlayer ? kBottomNavigationBarHeight + 10 : 0,
          left: playerCubit.isMiniPlayer ? 15 : 0,
          right: playerCubit.isMiniPlayer ? 15 : 0,
          duration: const Duration(milliseconds: 0),
          child: Visibility(
            visible: !playerCubit.isHideBottomNavigator,
            child: Miniplayer(
                minHeight: Resizable.size(context, 60),
                onDismiss: () {
                  playerCubit.dismissMiniPlayer();
                },
                elevation: 8,
                controller: playerCubit.controller,
                maxHeight: Resizable.height(context),
                builder: (height, percentage) {
                  if(playerCubit.isFirstOpenMax) {
                    playerCubit.openMaxPlayer();
                    playerCubit.setFirstOpenMax(false);
                  }
                  if (percentage > 0.2 && playerCubit.isMiniPlayer) {
                    playerCubit.openMaxPlayer();
                  }
                  else if (percentage < 0.2 && !playerCubit.isMiniPlayer) {
                    playerCubit.openMiniPlayer();
                  }
                  if(percentage < 0.2) {
                    return const MinPlayerPodcast();
                  }
                  return const MaxPlayerPodcast();
                }
            ),
          ),
        );
      },
    );
  }
}
