import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:poca/models/episode.dart';

class Playlist {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> episodesList;

  Playlist({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.episodesList,
    required this.description,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    var episodes = <String>[];
    if (json['episodesList'] != null) {
      json['episodesList'].forEach((v) {
        episodes.add(jsonEncode(v));
      });
    }
    return Playlist(
        id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        name: json['name'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        episodesList: episodes,
        description: json['description'] ?? '');
  }

  Playlist copyWith({
    String? id,
    String? userId,
    String? name,
    String? imageUrl,
    List<String>? episodesList,
    String? description,
  }) {
    return Playlist(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      episodesList: episodesList ?? this.episodesList,
      description: description ?? this.description,
    );
  }
}
