import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/account/playlist/base_bottom_sheet.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/providers/api/api_playlist.dart';
import 'package:poca/screens/playlist_detail_screen.dart';
import 'package:poca/screens/playlist_screen.dart';
import 'package:poca/services/cloud_service.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/loading_progress.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../../models/episode.dart';
import '../../../utils/resizable.dart';
import '../../blocs/player_cubit.dart';
import '../../blocs/user_cubit.dart';

class EditPlayList extends StatelessWidget {
  const EditPlayList({super.key, required this.plCubit, required this.plDCubit});

  final PlaylistCubit plCubit;
  final PlaylistDetailCubit plDCubit;

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: BlocProvider(
        create: (context) => EditPlaylist(plDCubit.playlist)..load(plDCubit.listEpisode),
        child: BlocBuilder<EditPlaylist, int>(
          builder: (context, state) {
            final editCubit = context.read<EditPlaylist>();
            final userCubit = context.read<UserCubit>();
            return SizedBox(
              height: Resizable.height(context) * 0.95,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         TextButton(
                             onPressed: () async {
                               Navigator.pop(context);
                             },
                             child: const Text(
                               'Cancel',
                               style: TextStyle(
                                   color: Colors.white, fontWeight: FontWeight.w700),
                             )),
                         Text(
                           'Edit Playlist',
                           style: TextStyle(
                               color: Colors.white, fontWeight: FontWeight.w700 , fontSize: Resizable.font(context, 25)),
                         ),
                         TextButton(
                             onPressed: () async {
                               if(editCubit.isCreating) {
                                 CustomToast.showBottomToast(
                                     context, 'Wait for updating');
                                 return;
                               }
                               if (editCubit.controller.text.isEmpty) {
                                 CustomToast.showBottomToast(
                                     context, 'Name playlist cannot empty');
                                 return;
                               }
                               if (plCubit.listPlaylist
                                   .map((e) => e.name.toLowerCase())
                                   .contains(editCubit.controller.text.toLowerCase() ) && editCubit.controller.text.toLowerCase() != editCubit.playlist.name.toLowerCase()) {
                                 CustomToast.showBottomToast(
                                     context, 'Name playlist already existed');
                                 return;
                               }
                               var url = '';
                               if(editCubit.image != null) {
                                 url = await CloudService.instance.uploadImage(
                                     File(editCubit.image!.path),
                                     DateTime.now().millisecondsSinceEpoch.toString());
                               }

                               var data = {
                                 'name': editCubit.controller.text,
                                 'description': editCubit.desController.text,
                                 'episodesList': editCubit.listEpisode.map((e) => e.id.toString()).toList(),
                                 'imageUrl': url.isEmpty ? editCubit.playlist.imageUrl : url,
                               };
                               debugPrint(url);
                               editCubit.updateCreate(true);
                               final res = await ApiPlaylist.instance
                                   .updatePlaylist(editCubit.playlist.id , userCubit.state!.id, data);
                               debugPrint(res.toString());
                               if (res) {
                                 await plCubit.load();
                                 plDCubit.updatePlaylist(editCubit.playlist.copyWith(
                                     name: editCubit.controller.text,
                                     description: editCubit.desController.text,
                                     episodesList: editCubit.listEpisode.map((e) => e.id.toString()).toList(),
                               imageUrl: url.isEmpty ? editCubit.playlist.imageUrl : url,
                                 ));
                                 editCubit.updateCreate(false);
                                 if (context.mounted) {
                                   Navigator.pop(context);
                                 }
                               } else {
                                 editCubit.updateCreate(false);
                                 if (context.mounted) {
                                   CustomToast.showBottomToast(
                                       context, 'Something error');
                                 }
                               }
                             },
                             child: const Text(
                               'Save',
                               style: TextStyle(
                                   color: Colors.white, fontWeight: FontWeight.w700),
                             )),
                       ],
                     ),
                   ),
                    const SizedBox(
                      height: 20,
                    ),
                    editCubit.image == null ? NetworkImageCustom(
                        url: editCubit.playlist.imageUrl, 
                        borderRadius: BorderRadius.circular(20),
                      width: Resizable.size(context, 220),
                      height: Resizable.size(context, 220),
                    )  : Container(
                      width: Resizable.size(context, 220),
                      height: Resizable.size(context, 220),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: editCubit.image == null
                              ? null
                              : DecorationImage(
                              image: FileImage(File(editCubit.image!.path)),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                          debugPrint(image!.path);
                          await editCubit.update(image);
                        },
                        child: const Text(
                          'Edit photo',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )),
                    SizedBox(
                      width: Resizable.width(context) * 0.8,
                      child: TextFormField(
                        controller: editCubit.controller,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white , fontWeight: FontWeight.w700 , fontSize: 20 ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Give your playlist a name',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),

                    SizedBox(
                      width: Resizable.width(context) * 0.8,
                      child: TextFormField(
                        controller: editCubit.desController,
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white , fontWeight: FontWeight.w500 , fontSize: 15 ),
                        decoration: const InputDecoration(

                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Give your description',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 20)),
                      child: Column(
                        children: [
                          ...editCubit.listEpisode.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  IconButton(onPressed: () {
                                    editCubit.removeEpisode(e.id);
                                  },
                                      color: Colors.white,
                                      splashRadius: 20,
                                      icon: const Icon(Icons.remove_circle_outline)),
                                  const SizedBox(width: 20,),
                                  Expanded(
                                    child: Text(
                                      e.title,
                                      maxLines: 3 ,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white , fontSize: Resizable.font(context, 15)),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList()
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (editCubit.isCreating)
                      const LoadingProgress(
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditPlaylist extends Cubit<int> {
  EditPlaylist(this.playlist) : super(0);
  final Playlist playlist;
  XFile? image;
  TextEditingController controller = TextEditingController();
  TextEditingController desController = TextEditingController();
  bool isCreating = false;
  List<Episode> listEpisode = [];
  load(List<Episode> list) {
    controller.text = playlist.name;
    desController.text = playlist.description;
    listEpisode = [...list];
    emit(state + 1);
  }
  update(XFile? img) {
    image = img;
    emit(state + 1);
  }

  updateCreate(bool value) {
    isCreating = value;
    emit(state + 1);
  }

  removeEpisode(String id) {
    listEpisode.removeWhere((element) => element.id == id);
    emit(state + 1);
  }
}
