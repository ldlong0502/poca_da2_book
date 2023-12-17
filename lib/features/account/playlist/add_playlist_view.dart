import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/account/playlist/base_bottom_sheet.dart';
import 'package:poca/providers/api/api_playlist.dart';
import 'package:poca/screens/playlist_screen.dart';
import 'package:poca/services/cloud_service.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../../utils/resizable.dart';
import '../../blocs/player_cubit.dart';
import '../../blocs/user_cubit.dart';

class AddPlaylistView extends StatelessWidget {
  const AddPlaylistView({super.key, required this.cubit});

  final PlaylistCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: BlocProvider(
        create: (context) => AddPlaylistCubit(),
        child: BlocBuilder<AddPlaylistCubit, int>(
          builder: (context, state) {
            final addCubit = context.read<AddPlaylistCubit>();
            final userCubit = context.read<UserCubit>();
            return SizedBox(
              height: Resizable.height(context) * 0.95,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: Resizable.size(context, 220),
                      height: Resizable.size(context, 220),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: addCubit.image == null
                              ? null
                              : DecorationImage(
                                  image: FileImage(File(addCubit.image!.path)),
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
                          await addCubit.update(image);
                        },
                        child: const Text(
                          'Add photo',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )),
                    SizedBox(
                      width: Resizable.width(context) * 0.8,
                      child: TextFormField(
                        controller: addCubit.controller,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
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
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () async {
                          if(addCubit.isCreating) {
                            CustomToast.showBottomToast(
                                context, 'Wait for creating');
                            return;
                          }
                          if (addCubit.image == null) {
                            CustomToast.showBottomToast(
                                context, 'Image cannot empty');
                            return;
                          }
                          if (addCubit.controller.text.isEmpty) {
                            CustomToast.showBottomToast(
                                context, 'Name playlist cannot empty');
                            return;
                          }
                          if (cubit.listPlaylist
                              .map((e) => e.name.toLowerCase())
                              .contains(addCubit.controller.text.toLowerCase())) {
                            CustomToast.showBottomToast(
                                context, 'Name playlist already existed');
                            return;
                          }
                          var url = await CloudService.instance.uploadImage(
                              File(addCubit.image!.path),
                              DateTime.now().millisecondsSinceEpoch.toString());

                          var data = {
                            'name': addCubit.controller.text,
                            'description': '',
                            'episodesList': [],
                            'imageUrl': url,
                          };
                          debugPrint(url);
                          addCubit.updateCreate(true);
                          final res = await ApiPlaylist.instance
                              .addPlaylist(userCubit.state!.id, data);
                          debugPrint(res.toString());
                          if (res) {
                            await cubit.load();
                            addCubit.updateCreate(false);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            addCubit.updateCreate(false);
                            if (context.mounted) {
                              CustomToast.showBottomToast(
                                  context, 'Something error');
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(secondaryColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1000))),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 20))),
                        child: Text(
                          addCubit.isCreating ? 'Creating...' : 'Create',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    if (addCubit.isCreating)
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

class AddPlaylistCubit extends Cubit<int> {
  AddPlaylistCubit() : super(0);

  XFile? image;
  TextEditingController controller = TextEditingController();
  bool isCreating = false;

  update(XFile? img) {
    image = img;
    emit(state + 1);
  }

  updateCreate(bool value) {
    isCreating = value;
    emit(state + 1);
  }
}
