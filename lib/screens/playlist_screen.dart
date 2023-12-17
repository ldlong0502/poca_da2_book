import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/features/account/playlist/add_playlist_view.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/providers/api/api_playlist.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/screens/base_screen.dart';
import 'package:poca/screens/playlist_detail_screen.dart';
import 'package:poca/utils/navigator_custom.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/loading_progress.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../configs/constants.dart';
import '../utils/resizable.dart';
import '../widgets/app_bar_custom.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom('', context),
      body: BlocProvider(
        create: (context) => PlaylistCubit(context)..load(),
        child: BlocBuilder<PlaylistCubit, int>(
          builder: (context, state) {
            if (state == 0) return const LoadingProgress();
            final cubit = context.read<PlaylistCubit>();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        var text = "Your playlist";
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
                                onAddPlaylist(context, cubit);
                              },
                              splashRadius: 20,
                              iconSize: Resizable.size(context, 25),
                              color: primaryColor,
                              icon: const Icon(
                                Icons.add,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                if (cubit.listPlaylist.isEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your playlist is empty!\nTry with first playlist',
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
                                title: 'Add first Playlist',
                                fontSize: 17,
                                onTap: () {
                                  onAddPlaylist(context, cubit);
                                },
                                backgroundColor: primaryColor,
                                textColor: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                if (cubit.listPlaylist.isNotEmpty)
                  Expanded(
                      child: GridView.builder(
                          itemCount: cubit.listPlaylist.length,
                          padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 15),
                              horizontal: Resizable.padding(context, 20)),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: Resizable.padding(context, 15),
                            mainAxisSpacing: Resizable.padding(context, 15),
                          ),
                          itemBuilder: (context, index) {
                            var playlist = cubit.listPlaylist[index];
                            return GestureDetector(
                              onTap: () {
                                NavigatorCustom.pushNewScreen(context, PlaylistDetailScreen(playlist: playlist, plCubit: cubit), AppRoutes.playlistDetail);
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                      child: LayoutBuilder(builder: (context, c) {
                                    return NetworkImageCustom(
                                      url: playlist.imageUrl,
                                      width: c.maxWidth,
                                      height: c.maxHeight,
                                      borderRadius: BorderRadius.circular(20),
                                    );
                                  })),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    playlist.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 20)),
                                  )
                                ],
                              ),
                            );
                          })),
              ],
            );
          },
        ),
      ),
    );
  }

  onAddPlaylist(BuildContext context , PlaylistCubit cubit) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor:
        primaryColor.withOpacity(0.9),
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
            )),
        builder: (context) {
          return AddPlaylistView(cubit: cubit);
        });
  }
}

class PlaylistCubit extends Cubit<int> {
  PlaylistCubit(this.context) : super(0);

  final BuildContext context;
  final bool isSearching = false;
  List<Playlist> listPlaylist = [];

  load() async {
    var userCubit = context.read<UserCubit>();
    listPlaylist =
        await ApiPlaylist.instance.getListPlaylistByUser(userCubit.state!.id);
    emit(state + 1);
  }
}
