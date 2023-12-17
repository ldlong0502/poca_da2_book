import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/local/history_podcast_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/services/history_services.dart';

class RecentlyPlayCubit extends Cubit<int> {
  RecentlyPlayCubit() : super(0);
List<HistoryPodcast> listHistory = [];

  final local = PreferenceProvider.instance;

  bool isGrid = false;
  updateView() {
    isGrid = !isGrid;
    emit(state+1);
  }

  load() async {
    listHistory = await HistoryPodcastProvider.instance.getListHistoryPodcast();

    emit(state + 1);
  }


  removeHistory(Podcast podcast) async {
    await HistoryService.instance.removeHistory(podcast);
    load();
  }
}
