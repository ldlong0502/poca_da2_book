import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/account/playlist/base_bottom_sheet.dart';
import 'package:poca/features/account/playlist/edit_playlist.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/features/dialogs/delete_playlist_dialog.dart';
import 'package:poca/providers/api/api_playlist.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../../screens/playlist_detail_screen.dart';
import '../../../screens/playlist_screen.dart';
import '../../../utils/dialogs.dart';

class MoreActionPlaylist extends StatelessWidget {
  const MoreActionPlaylist(
      {super.key,
      required this.plCubit,
      required this.plDCubit,
      required this.onEdit});

  final PlaylistCubit plCubit;
  final PlaylistDetailCubit plDCubit;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    var playlist = plDCubit.playlist;
    final userCubit = context.read<UserCubit>();
    var mapItems = [
      {
        'title': 'Edit',
        'icon': const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        'onPress': () async {
          Navigator.pop(context);
          onEdit();
        },
      },
      {
        'title': 'Delete playlist',
        'icon': const Icon(
          Icons.remove_circle_outline,
          color: Colors.white,
        ),
        'onPress': () {
          Dialogs.showDialogCustom(context,
              DeletePlaylistDialog(onDelete: () async {
            final res = await ApiPlaylist.instance
                .deletePlaylist(playlist.id, userCubit.state!.id);

            if (res) {

              if (context.mounted) {
                Navigator.pop(context);
                CustomToast.showBottomToast(context, 'Deleted this playlist');
                await plCubit.load();
                if (context.mounted) {
                  Navigator.popUntil(
                      context, ModalRoute.withName(AppRoutes.playlist));
                }
              }
            }
            else {
              if (context.mounted) {
                CustomToast.showBottomToast(context, 'Something wrong');
              }
            }
          }));
        }
      },
      {
        'title': 'Download',
        'icon': const Icon(
          Icons.download,
          color: Colors.white,
        ),
        'onPress': () {},
      }
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
                      url: playlist.imageUrl,
                      borderRadius: BorderRadius.circular(20)),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    playlist.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Resizable.font(context, 20),
                        fontWeight: FontWeight.w700),
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
