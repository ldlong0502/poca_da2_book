import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/home_cubit.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/resizable.dart';

import '../../widgets/network_image_custom.dart';

class NewReleaseWidget extends StatelessWidget {
  const NewReleaseWidget({super.key, required this.homeCubit});

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    var podcast = homeCubit.podcastContainLatestEpisode!;
    var episode = homeCubit.latestEpisode!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              NetworkImageCustom(
                url: podcast.imageUrl,
                height: 60,
                width: 60,
                borderRadius: BorderRadius.circular(1000),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'New release from',
                      style: TextStyle(
                          fontSize: Resizable.font(context, 16),
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      podcast.host,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Resizable.font(context, 20),
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: Resizable.size(context, 120),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(child: LayoutBuilder(builder: (context, c) {
                  return NetworkImageCustom(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    url: podcast.imageUrl,
                    width: c.maxWidth,
                    height: c.maxHeight,
                  );
                })),
                Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.black87,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 15),
                            vertical: Resizable.padding(context, 10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              episode.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${ConvertUtils.convertIntToDateString(episode.publishDate * 1000)} - ${ConvertUtils.convertIntToDuration(episode.duration)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize:
                                              Resizable.font(context, 13),
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      episode.favoritesList.length.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize:
                                              Resizable.font(context, 13),
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Icon(
                                      Icons.favorite,
                                      color: primaryColor,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                    size: Resizable.size(context, 35),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    var index = podcast.episodesList
                                        .indexWhere((element) =>
                                            element.id == episode.id);
                                    context
                                        .read<PlayerCubit>()
                                        .listen(podcast, index);
                                  },
                                  child: Icon(
                                    Icons.play_circle_outline_rounded,
                                    color: Colors.white,
                                    size: Resizable.size(context, 35),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
