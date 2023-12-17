import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/podcast_cubit.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/features/podcast/row_info_podcast.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/screens/base_screen.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/loading_progress.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../utils/convert_utils.dart';
import 'app_bar_podcast.dart';

class PodcastDetailView extends StatelessWidget {
  const PodcastDetailView({super.key, required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: '',
      child: BlocProvider(
        create: (context) => PodcastCubit(podcast.id)..load(),
        child: BlocBuilder<PodcastCubit, int>(
          builder: (context, state) {
            var podcastCubit = context.read<PodcastCubit>();
            if (state == 0) return const LoadingProgress();
            return CustomScrollView(
              controller: podcastCubit.scrollController,
              slivers: [
                AppBarPodcast(podcastCubit: podcastCubit),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ExpandableText(
                          podcastCubit.podcast!.description,
                          expandText: 'see more',
                          textAlign: TextAlign.start,
                          linkStyle: const TextStyle(fontWeight: FontWeight.bold),
                          collapseText: 'show less',
                          style: TextStyle(
                              fontSize: Resizable.font(context, 16),
                              color: secondaryColor,
                              fontWeight: FontWeight.w500),
                          maxLines: 4,
                          linkColor: primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ...podcastCubit.podcast!.episodesList
                              .map((e) => InkWell(
                            onTap: () {
                              context.read<PlayerCubit>().listen(
                                  podcastCubit.podcast!,
                                  podcastCubit.podcast!.episodesList
                                      .indexOf(e));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  NetworkImageCustom(
                                    url: e.imageUrl,
                                    height: Resizable.size(context, 85),
                                    width: Resizable.size(context, 85),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.title,
                                            style: TextStyle(
                                                fontSize:
                                                Resizable.font(context, 16),
                                                color: textColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${ConvertUtils.convertIntToDateString(e.publishDate * 1000)} - ${ConvertUtils.convertIntToDuration(e.duration)}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: Resizable.font(
                                                        context, 13),
                                                    color: primaryColor,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    e.favoritesList.length
                                                        .toString(),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize:
                                                        Resizable.font(
                                                            context, 13),
                                                        color: primaryColor,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                  const Icon(
                                                    Icons.favorite,
                                                    color: primaryColor,
                                                  )
                                                ],
                                              ),
                                              InkWell(
                                                  onTap: () {},
                                                  child: const Icon(
                                                    Icons.more_horiz_rounded,
                                                    color: primaryColor,
                                                  ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ))
                              .toList()
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
