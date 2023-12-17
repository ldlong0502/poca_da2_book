import 'package:flutter/material.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_provider.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';

import '../../models/podcast.dart';

class ApiPlaylist {
  ApiPlaylist._privateConstructor();

  static final ApiPlaylist _instance = ApiPlaylist._privateConstructor();

  static ApiPlaylist get instance => _instance;

  Future<List<Playlist>> getListPlaylistByUser(String id) async {
    var response = await ApiProvider().get('/playlists/$id');
    if (response == null) return [];

    if (response.statusCode == 200) {
      debugPrint(response.toString());
      List<Playlist> data =
          (response.data as List).map((e) => Playlist.fromJson(e)).toList();
      return data;
    } else {
      return [];
    }
  }

  Future<bool> addPlaylist(String idUser, Map<String, dynamic> data) async {
    var response = await ApiProvider().post('/playlists/$idUser', data: data);
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> updatePlaylist(String idPlaylist , String idUser, Map<String, dynamic> data) async {
    var response = await ApiProvider().update('/playlists/$idUser/$idPlaylist', data: data);
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> deletePlaylist(String idPlaylist , String idUser) async {
    var response = await ApiProvider().delete('/playlists/$idUser/$idPlaylist');
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> addEpisodeToPlaylist(String playlistId, String episodeId) async {
    var response = await ApiProvider()
        .post('/playlists/$playlistId/addEpisode/$episodeId');
    if (response == null) return false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
