import 'package:flutter/material.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

import '../../models/podcast.dart';

class ApiEpisode {
  ApiEpisode._privateConstructor();

  static final ApiEpisode _instance = ApiEpisode._privateConstructor();

  static ApiEpisode get instance => _instance;

  Future<Episode?> getEpisodeLatest() async {
    var response = await ApiProvider().get('/podcasts/latest-episode');
    debugPrint(response.toString());
    if(response == null) return null;

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return Episode.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<bool> increaseListens(String podcastId, String episodeId) async {
    var response = await ApiProvider().update('/podcasts/$podcastId/increment-listens/$episodeId');
    debugPrint(response.toString());
    if(response == null) return false;

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return true;
    } else {
      return false;
    }
  }

  Future<List<Episode>> search(String value) async {
    var response = await ApiProvider().get('/podcasts/episodes/search?keyword=$value' );
    if(response == null) return [];

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      List<Episode> data =
      (response.data as List).map((e) => Episode.fromJson(e)).toList();
      return data;
    } else {
      return [];
    }
  }
  Future<Episode?> getEpisode(String id) async {
    print('=>>>>>>>>$id');
    var response = await ApiProvider().get('/podcasts/episodes/$id');
    debugPrint(response.toString());
    if(response == null) return null;

    if(response.statusCode == 200) {
      debugPrint(response.toString());
      return Episode.fromJson(response.data);
    } else {
      return null;
    }
  }

}