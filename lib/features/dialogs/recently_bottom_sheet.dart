import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/account/playlist/base_bottom_sheet.dart';
import 'package:poca/features/account/playlist/edit_playlist.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/recently_play_cubit.dart';
import 'package:poca/features/blocs/subscribe_cubit.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/features/dialogs/delete_playlist_dialog.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_playlist.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../../screens/playlist_detail_screen.dart';
import '../../../screens/playlist_screen.dart';
import '../../../utils/dialogs.dart';
import '../../providers/api/api_podcast.dart';
import '../../utils/navigator_custom.dart';
import '../podcast/podcast_detail_view.dart';

class RecentlyBottomSheet extends StatelessWidget {
  const RecentlyBottomSheet(
      {super.key, required this.podcast, required this.episode,
      });
  final Podcast podcast;
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final recCubit = context.read<RecentlyPlayCubit>();
    var mapItems = [
      {
        'title': 'Remove history',
        'icon': const Icon(
          Icons.remove_circle_outline,
          color: Colors.white,
        ),
        'onPress': () async {
          await recCubit.removeHistory(podcast);
          Navigator.pop(context);
        },
      },
      {
        'title': 'Detail Podcast',
        'icon': const Icon(
          Icons.podcasts_outlined,
          color: Colors.white,
        ),
        'onPress': () {
          Navigator.pop(context);
          NavigatorCustom.pushNewScreen(context, PodcastDetailView(podcast: podcast), AppRoutes.podcastDetail);
        }
      },
    ];
    return BaseBottomSheet(
      child: SizedBox(
        height: Resizable.height(context) * 0.4,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20)),
              child: Row(
                children: [
                  NetworkImageCustom(
                      height: Resizable.size(context, 100),
                      width: Resizable.size(context, 100),
                      url: podcast.imageUrl,
                      borderRadius: BorderRadius.circular(20)),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcast.title,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Resizable.font(context, 20),
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          episode.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Resizable.font(context, 15),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
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
              child: Column(
                children: [
                  ...mapItems.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: e['onPress'] as Function(),
                        child: Row(
                          children: [
                            e['icon'] as Widget,
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              e['title'] as String,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Resizable.font(context, 20)),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
