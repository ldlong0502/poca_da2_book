import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/features/account/playlist/add_episode.dart';
import 'package:poca/features/account/playlist/add_playlist_view.dart';
import 'package:poca/features/account/playlist/more_action_playlist.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_playlist.dart';
import 'package:poca/screens/base_screen.dart';
import 'package:poca/screens/playlist_screen.dart';
import 'package:poca/services/dynamic_links_service.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/loading_progress.dart';
import 'package:poca/widgets/network_image_custom.dart';
import 'package:share_plus/share_plus.dart';

import '../configs/constants.dart';
import '../features/account/playlist/edit_playlist.dart';
import '../features/blocs/player_cubit.dart';
import '../models/podcast.dart';
import '../utils/convert_utils.dart';
import '../utils/dialogs.dart';
import '../utils/resizable.dart';
import '../widgets/app_bar_custom.dart';

class PlaylistDetailScreen extends StatelessWidget {
  const PlaylistDetailScreen(
      {super.key, required this.playlist, required this.plCubit});

  final Playlist playlist;
  final PlaylistCubit plCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom('', context),
      body: BlocProvider(
        create: (context) => PlaylistDetailCubit(playlist)..load(),
        child: BlocBuilder<PlaylistDetailCubit, int>(
          builder: (context, state) {
            if (state == 0) return const LoadingProgress();
            final plDCubit = context.read<PlaylistDetailCubit>();
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: NetworkImageCustom(
                      url: plDCubit.playlist.imageUrl,
                      borderRadius: BorderRadius.circular(20),
                      width: Resizable.size(context, 250),
                      height: Resizable.size(context, 250),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plDCubit.playlist.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 30)),
                            ),
                            Builder(builder: (context) {
                              var hour = plDCubit.listEpisode.fold(
                                  0,
                                  (previousValue, element) =>
                                      previousValue + element.duration);
                              return Text(
                                ConvertUtils.convertIntToDuration(hour),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              );
                            })
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  plDCubit.updateSort(!plDCubit.isSort);
                                },
                                splashRadius: 20,
                                icon: Image.asset(
                                    'assets/icons/ic_${!plDCubit.isSort ? 'sort' : 'sort_random'}.png')),
                            IconButton(
                                onPressed: () {
                                  if (plDCubit.podcast == null) return;
                                  context.read<PlayerCubit>().listen(
                                        plDCubit.podcast!,
                                      );
                                },
                                splashRadius: 30,
                                color: primaryColor,
                                iconSize: 50,
                                icon: const Icon(Icons.play_circle)),
                            IconButton(
                                onPressed: () {
                                  onMoreAction(context, plDCubit);
                                },
                                splashRadius: 20,
                                color: secondaryColor,
                                icon: const Icon(Icons.more_horiz_rounded)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 20)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ExpandableText(
                        plDCubit.playlist.description,
                        expandText: 'Show more',
                        collapseText: 'Show less',
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        linkStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Resizable.font(context, 15),
                            color: secondaryColor),
                        linkColor: purpleColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (playlist.episodesList.isEmpty)
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Let\'s start building your playlist',
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
                                    title: 'Add to this playlist',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    onTap: () {
                                      onAddEpisode(context, plDCubit);
                                    },
                                    backgroundColor: primaryColor,
                                    textColor: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (playlist.episodesList.isNotEmpty) ...[
                    InkWell(
                      onTap: () {
                        onAddEpisode(context, plDCubit);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 20, right: 20),
                        child: Row(
                          children: [
                            Container(
                              height: Resizable.size(context, 85),
                              width: Resizable.size(context, 85),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.add,
                                color: primaryColor,
                                size: Resizable.size(context, 50),
                              )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add to this playlist',
                                  style: TextStyle(
                                      fontSize: Resizable.font(context, 16),
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ...plDCubit.listEpisode.map((e) {
                          return InkWell(
                            onTap: () {
                              if (plDCubit.podcast == null) return;
                              context.read<PlayerCubit>().listen(
                                  plDCubit.podcast!,
                                  plDCubit.podcast!.episodesList.indexOf(e));
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
                                                fontSize:
                                                    Resizable.font(context, 13),
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                e.favoritesList.length
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: Resizable.font(
                                                        context, 13),
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const Icon(
                                                Icons.favorite,
                                                color: primaryColor,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                              onTap: () {
                                                try {
                                                  DynamicLinksService.instance
                                                      .createLink('episodes')
                                                      .then((value) =>
                                                      Share.share(value));
                                                } catch(err) {
                                                  Share.share('https://pocademo.page.link/episodes');
                                                }

                                              },
                                              child: const Icon(
                                                Icons.ios_share,
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
                          );
                        }).toList()
                      ],
                    ),
                  ],
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  onAddEpisode(BuildContext context, PlaylistDetailCubit plDCubit) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: primaryColor.withOpacity(0.9),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return AddEpisode(
            plCubit: plCubit,
            plDCubit: plDCubit,
          );
        });
  }

  onMoreAction(BuildContext context, PlaylistDetailCubit plDCubit) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: primaryColor.withOpacity(0.9),
        builder: (cc) {
          return MoreActionPlaylist(
            plCubit: plCubit,
            plDCubit: plDCubit,
            onEdit: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              if (context.mounted) {
                Dialogs.showBottomSheet(context,
                    EditPlayList(plCubit: plCubit, plDCubit: plDCubit));
              }
            },
          );
        });
  }
}

class PlaylistDetailCubit extends Cubit<int> {
  PlaylistDetailCubit(this.playlist) : super(0);

  Playlist playlist;
  List<Episode> listEpisode = [];
  List<Episode> listBaseEpisode = [];

  Podcast? podcast;
  bool isSort = false;

  load() async {
    listEpisode.clear();
    for (var item in playlist.episodesList) {
      var epi = await ApiEpisode.instance.getEpisode(item.replaceAll('"', ''));
      if (epi != null) {
        listEpisode.add(epi);
      }
      listBaseEpisode = [...listEpisode];
    }
    podcast = Podcast(
        id: playlist.id,
        title: playlist.name,
        description: playlist.description,
        topicsList: [],
        host: '',
        episodesList: listEpisode,
        publishDate: 0,
        subscribesList: [],
        favoritesList: [],
        imageUrl: playlist.imageUrl);

    emit(state + 1);
  }

  updateSort(bool value) {
    isSort = value;
    if (isSort) {
      listEpisode.shuffle();
    } else {
      listEpisode = [...listBaseEpisode];
    }
    emit(state + 1);
  }

  updatePlaylist(Playlist pl) {
    playlist = pl;
    load();
  }
}
