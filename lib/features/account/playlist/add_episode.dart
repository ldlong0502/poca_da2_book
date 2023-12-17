import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/account/playlist/base_bottom_sheet.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_playlist.dart';
import 'package:poca/screens/playlist_detail_screen.dart';
import 'package:poca/screens/playlist_screen.dart';
import 'package:poca/services/cloud_service.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/custom_text_field.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../../models/episode.dart';
import '../../../providers/preference_provider.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';
import '../../blocs/user_cubit.dart';

class AddEpisode extends StatelessWidget {
  const AddEpisode({super.key, required this.plCubit, required this.plDCubit});

  final PlaylistCubit plCubit;
  final PlaylistDetailCubit plDCubit;

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: BlocProvider(
        create: (context) => AddEpisodeCubit()..search(''),
        child: BlocBuilder<AddEpisodeCubit, int>(
          builder: (context, state) {
            final addCubit = context.read<AddEpisodeCubit>();
            final userCubit = context.read<UserCubit>();

            return SizedBox(
              height: Resizable.height(context) * 0.95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Add to this playlist',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 25)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 20)),
                      child: CustomTextField(
                          controller: addCubit.controller,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          title: 'Search',
                          isMaxSize: true,
                          textColor: Colors.white,
                          onValidate: () {},
                          onChanged: (value) {
                            addCubit.search(value);
                          },
                          isPassword: false),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 20)),
                    child: Text(
                      addCubit.isSearch
                          ? 'Suggested episodes'
                          : 'Recently Search',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...addCubit.listEpisode.map((e) {
                            return Container(
                              height: Resizable.size(context, 70),
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: Row(
                                children: [
                                  NetworkImageCustom(
                                    url: e.imageUrl,
                                    borderRadius: BorderRadius.circular(20),
                                    height: Resizable.size(context, 70),
                                    width: Resizable.size(context, 70),
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
                                        e.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: Resizable.font(context, 18),
                                            color: textColor,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        ConvertUtils.convertIntToDuration(
                                            e.duration),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: Resizable.font(context, 14),
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                                  SizedBox(
                                      width: Resizable.size(context, 50),
                                      child: Builder(builder: (context) {
                                        var isContain = plDCubit
                                            .listEpisode.map((e) => e.id)
                                            .contains(e.id);
                                        return isContain
                                            ? Container()
                                            : IconButton(
                                                onPressed: () async {
                                                  final res = await ApiPlaylist.instance.addEpisodeToPlaylist(plDCubit.playlist.id, e.id);

                                                  if(res) {
                                                   if(context.mounted) {
                                                     CustomToast.showBottomToast(context, 'Added to ${plDCubit.playlist.name}');
                                                   }
                                                  }
                                                  else {
                                                    if(context.mounted) {
                                                      CustomToast.showBottomToast(context, 'Error! Please try again.');
                                                    }
                                                  }
                                                  await plCubit.load();

                                                  await plDCubit.updatePlaylist(plDCubit.playlist.copyWith(
                                                    episodesList: plDCubit.playlist.episodesList..add(e.id)
                                                  ));
                                                  if(context.mounted) {
                                                    Navigator.pop(context);
                                                  }

                                                },
                                                splashRadius: 20,
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.white,
                                                ));
                                      }))
                                ],
                              ),
                            );
                          }).toList(),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if(addCubit.listEpisode.isNotEmpty && !addCubit.isSearch)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: TextButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(const BorderSide(color: Colors.white))
                          ),
                            onPressed: () async {
                              await addCubit.clearHistory();
                            },
                            child: const Text(
                              'Clear recent searches',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w700),
                            )),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AddEpisodeCubit extends Cubit<int> {
  AddEpisodeCubit() : super(0);

  List<Episode> listEpisode = [];
  TextEditingController controller = TextEditingController();

  bool isSearch = false;

  Future<List<Episode>> getHistorySearch() async {
    var json = await PreferenceProvider.instance
        .getList('account_playlist_history_search');

    print('=>>>>>$json');
    if (json == null) return [];
    List<Episode> data =
        (json).map((e) => Episode.fromJson(jsonDecode(e))).toList();
    return data;
  }


  clearHistory() async {
    await PreferenceProvider.instance
        .removeJsonToPref('account_playlist_history_search');
    listEpisode = [];
    emit(state+1);
  }
  search(String value) async {
    if (value.isEmpty) {
      isSearch = false;
      listEpisode = await getHistorySearch();
    } else {
      isSearch = true;
      listEpisode = await ApiEpisode.instance.search(value);
      for(var item in listEpisode) {
        PreferenceProvider.instance.insertIntoList('account_playlist_history_search',jsonEncode( item.toJson()));
      }
    }
    emit(state + 1);
  }

  updateSearch(bool value) {
    isSearch = value;
    emit(state + 1);
  }
}
