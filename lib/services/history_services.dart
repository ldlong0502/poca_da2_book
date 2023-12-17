import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/local/history_podcast_provider.dart';
import 'package:poca/providers/preference_provider.dart';

class HistoryService {
  HistoryService._privateConstructor();

  static final HistoryService _instance = HistoryService._privateConstructor();

  static HistoryService get instance => _instance;

  updateNewHistory(Podcast podcast, int indexChapter, int duration) async {
    var listHistory =
        await HistoryPodcastProvider.instance.getListHistoryPodcast();
    final index =
        listHistory.map((e) => e.podcast.id).toList().indexOf(podcast.id);
    if (index != -1) {
      listHistory.removeAt(index);
    }
    var history = HistoryPodcast(
        podcast: podcast,
        duration: duration,
        indexChapter: indexChapter,
        dateUpdated: DateTime.now().millisecondsSinceEpoch);
    listHistory.insert(0, history);
    final json = jsonEncode(listHistory);
    await PreferenceProvider.instance.setString(AppConfigs.KEY_RECENTLY_PLAYED, json);

    debugPrint('=>>>>>>>>>>>>> ${listHistory.length}');
    
  }

  removeHistory(Podcast podcast) async {
    var listHistory =
    await HistoryPodcastProvider.instance.getListHistoryPodcast();
    final index =
    listHistory.map((e) => e.podcast.id).toList().indexOf(podcast.id);
    if (index != -1) {
      listHistory.removeAt(index);
    }
    final json = jsonEncode(listHistory);
    await PreferenceProvider.instance.setString(AppConfigs.KEY_RECENTLY_PLAYED, json);
  }
}
