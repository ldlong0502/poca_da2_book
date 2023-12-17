import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/subscribe_cubit.dart';
import 'package:poca/features/dialogs/recently_bottom_sheet.dart';
import 'package:poca/features/dialogs/subcsribe_bottom_sheet.dart';
import 'package:poca/features/podcast/podcast_detail_view.dart';
import 'package:poca/utils/dialogs.dart';

import '../configs/constants.dart';
import '../features/blocs/recently_play_cubit.dart';
import '../routes/app_routes.dart';
import '../utils/navigator_custom.dart';
import '../utils/resizable.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/custom_button.dart';
import '../widgets/network_image_custom.dart';

class RecentlySeeAll extends StatelessWidget {
  const RecentlySeeAll(
      {super.key, required this.cubit, required this.title});

  final RecentlyPlayCubit cubit;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom('', context),
      body: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<RecentlyPlayCubit, int>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        var text = title;
                        return Text(
                          text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 24),
                              color: textColor,
                              fontWeight: FontWeight.w600),
                        );
                      }),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                cubit.updateView();
                              },
                              splashRadius: 20,
                              iconSize: Resizable.size(context, 25),
                              color: primaryColor,
                              icon: Icon(
                                cubit.isGrid ? Icons.grid_view_rounded : Icons.sort,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                if (cubit.listHistory.isEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your subscription is empty!\nExplore and return again',
                            style: TextStyle(
                                fontSize: Resizable.font(context, 20),
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            child: CustomButton(
                                title: 'Explore Podcast',
                                fontSize: 17,
                                onTap: () {
                                  final playCubit = context.read<PlayerCubit>();
                                  playCubit.persistentTabController.jumpToTab(1);
                                },
                                backgroundColor: primaryColor,
                                textColor: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                if (cubit.listHistory.isNotEmpty && cubit.isGrid)
                  Expanded(
                      child: GridView.builder(
                          itemCount: cubit.listHistory.length,
                          padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 15),
                              horizontal: Resizable.padding(context, 20)),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: Resizable.padding(context, 15),
                            mainAxisSpacing: Resizable.padding(context, 15),
                          ),
                          itemBuilder: (context, index) {
                            var playlist = cubit.listHistory[index];
                            return GestureDetector(
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context, PodcastDetailView(podcast: playlist.podcast), AppRoutes.podcastDetail);
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                      child: LayoutBuilder(builder: (context, c) {
                                        return NetworkImageCustom(
                                          url: playlist.podcast.imageUrl,
                                          width: c.maxWidth,
                                          height: c.maxHeight,
                                          borderRadius: BorderRadius.circular(20),
                                        );
                                      })),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    playlist.podcast.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 20)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    playlist.podcast.episodesList[playlist.indexChapter].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 15)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    lineHeight: 6.0,
                                    percent: playlist.duration / (playlist.podcast.episodesList[playlist.indexChapter].duration * 1000),
                                    barRadius: const Radius.circular(1000),
                                    backgroundColor: Colors.grey.shade400,
                                    progressColor: Colors.blue,
                                  ),
                                ],
                              ),
                            );
                          })),
                if (cubit.listHistory.isNotEmpty && !cubit.isGrid)
                  Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 20)
                        ),
                        children: [
                          ...cubit.listHistory.map((e) {
                            return GestureDetector(
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context, PodcastDetailView(podcast: e.podcast), AppRoutes.podcastDetail);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    NetworkImageCustom(
                                      url: e.podcast.imageUrl,
                                      width: Resizable.size(context, 100),
                                      height: Resizable.size(context, 100),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.podcast.title,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Resizable.font(context, 20)),
                                          ),
                                          Text(
                                            e.podcast.episodesList[e.indexChapter].title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Resizable.font(context, 15)),
                                          ),
                                          const SizedBox(height: 5,),
                                          LinearPercentIndicator(
                                            padding: EdgeInsets.zero,
                                            lineHeight: 6.0,
                                            percent: e.duration / (e.podcast.episodesList[e.indexChapter].duration * 1000),
                                            barRadius: const Radius.circular(1000),
                                            backgroundColor: Colors.grey.shade400,
                                            progressColor: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(onPressed: () {
                                      Dialogs.showBottomSheet(context, RecentlyBottomSheet(podcast: e.podcast , episode: e.podcast.episodesList[e.indexChapter],));
                                    }, icon: const Icon(Icons.more_vert_rounded) , color: primaryColor , splashRadius: 20,)
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        ],
                      )),
              ],
            );
          },
        ),
      ),
    );
  }
}
