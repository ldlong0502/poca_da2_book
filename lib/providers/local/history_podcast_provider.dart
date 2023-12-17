import 'dart:convert';

import 'package:poca/configs/app_configs.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/providers/preference_provider.dart';

class HistoryPodcastProvider {
  HistoryPodcastProvider._privateConstructor();

  static final HistoryPodcastProvider _instance = HistoryPodcastProvider._privateConstructor();

  static HistoryPodcastProvider get instance => _instance;

  final local = PreferenceProvider.instance;
  Future<List<HistoryPodcast>> getListHistoryPodcast() async {
    var response = await local.getString(AppConfigs.KEY_RECENTLY_PLAYED);

    if(response.isEmpty) {
      return [];
    } else {
      List<HistoryPodcast> podcasts =
      (jsonDecode(response) as List).map((e) => HistoryPodcast.fromJson(e)).toList();
      podcasts.sort((a , b) => b.dateUpdated.compareTo(a.dateUpdated));
      return podcasts;
    }
  }
}