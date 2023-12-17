import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:poca/blocs/mini_player_cubit.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/utils/resizable.dart';

class MiniPlayerAudioBook extends StatelessWidget {
  const MiniPlayerAudioBook({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerCubit, int>(
      builder: (context, state) {
        final cubit = context.read<MiniPlayerCubit>();
        return Stack(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 8),
                        horizontal: Resizable.padding(context, 15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: cubit.currentAudioBook!.image,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          placeholder: (context, s) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Image.asset(
                                  'assets/images/book_temp.jpg'),
                            );
                          },
                          errorWidget: (context, s, _) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Image.asset(
                                  'assets/images/book_temp.jpg'),
                            );
                          },
                        ),
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Marquee(
                            text: cubit.currentAudioBook!.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: purpleColor,
                              fontSize: Resizable.font(context, 14),
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 20.0,
                            velocity: 10.0,
                            pauseAfterRound: const Duration(milliseconds: 500),
                            startPadding: 10.0,
                            accelerationDuration: const Duration(milliseconds: 100),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: const Duration(
                                milliseconds: 100),
                            decelerationCurve: Curves.easeOut,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: AutoSizeText(
                              cubit.currentAudioBook!.listMp3[cubit.indexChapter]
                                  .title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: pinkColor,
                                fontSize: Resizable.font(context, 12),
                              ),),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () {
                          cubit.seekPrevious(const Duration(seconds: 30));
                        },
                          icon: Icon(Icons.replay_30_rounded,
                            size: Resizable.size(context, 30),),
                          color: purpleColor,),
                        GestureDetector(
                          onTap: () {
                            if (cubit.isPlay && cubit.status == ProcessingState
                                .ready) {
                              cubit.pause();
                            }
                            else {
                              cubit.play();
                            }
                          },
                          child: Card(
                            color: Colors.grey.shade100,
                            elevation: 7,
                            shape: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(child: Icon(cubit.isPlay &&
                                  cubit.status == ProcessingState.ready ? Icons
                                  .pause_rounded : Icons.play_arrow_rounded,
                                  size: Resizable.size(context, 25)),),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
            IgnorePointer(
              ignoring: true,
              child: SizedBox(
                height: double.infinity,
                child: LinearProgressIndicator(
                  value: cubit.durationState.total == Duration.zero ? 0 : (cubit
                      .durationState.progress.inMilliseconds /
                      cubit.durationState.total.inMilliseconds),
                  // percent filled
                  valueColor: AlwaysStoppedAnimation<Color>(
                      pinkColor.withOpacity(0.4)),
                  backgroundColor: Colors.transparent,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
