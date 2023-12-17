import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/podcast_cubit.dart';
import 'package:poca/features/blocs/subscribe_cubit.dart';
import 'package:poca/features/home/subscribe_list.dart';
import 'package:poca/features/podcast/row_info_podcast.dart';
import 'package:poca/widgets/custom_button.dart';

import '../../models/user_model.dart';
import '../../utils/resizable.dart';
import '../blocs/player_cubit.dart';
import '../blocs/user_cubit.dart';

class AppBarPodcast extends StatelessWidget {
  const AppBarPodcast({super.key, required this.podcastCubit});

  final PodcastCubit podcastCubit;

  @override
  Widget build(BuildContext context) {
    podcastCubit.scrollController.addListener(() {
      if (podcastCubit.scrollController.offset > Resizable.size(context, 250)) {
        if (!podcastCubit.isShowMaxButton) {
          podcastCubit.changeShowMaxButton(true);
        }
      }
      else {
        if (podcastCubit.isShowMaxButton) {
          podcastCubit.changeShowMaxButton(false);
        }
      }
    });
    return SliverAppBar(
      expandedHeight: Resizable.size(context, 320),
      automaticallyImplyLeading: false,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              RowInfoPodcast(
                podcastCubit: podcastCubit,
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<UserCubit, UserModel?>(
                            builder: (context, state) {
                              if (state == null) return Container();
                              var isSub= podcastCubit.podcast!.subscribesList
                                  .map((e) => e.id)
                                  .contains(state.id);
                              return IconButton(
                                  onPressed: () async {
                                    await podcastCubit.updateSubscribes(context ,state);

                                    if(context.mounted) {
                                      context.read<SubscribeCubit>().load(state);
                                    }
                                  },
                                  icon:  Icon(
                                    isSub ? Icons.bookmark : Icons.bookmark_add_outlined,
                                    color: primaryColor,
                                  ));
                            },
                          ),
                          BlocBuilder<UserCubit, UserModel?>(
                            builder: (context, state) {
                              if (state == null) return Container();
                              var isFav = podcastCubit.podcast!.favoritesList
                                  .map((e) => e.id)
                                  .contains(state.id);
                              return IconButton(
                                  onPressed: () {
                                    podcastCubit.updateFav(context ,state);
                                  },
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: primaryColor,
                                  ));
                            },
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                                color: primaryColor,
                              )),
                        ],
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () {
              context
                  .read<PlayerCubit>()
                  .listen(podcastCubit.podcast!);
              podcastCubit.updateListens(context, 0);
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      primaryColor,
                      secondaryColor
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(1, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                width: podcastCubit.isShowMaxButton ? Resizable.width(context) *
                    0.9 : 200,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline, size: 30,
                        color: Colors.white,),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Play now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
