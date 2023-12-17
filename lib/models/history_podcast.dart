import 'package:flutter/cupertino.dart';
import 'package:poca/models/podcast.dart';

class HistoryPodcast {
  final Podcast podcast;
  final int duration;
  final int indexChapter;
  final int dateUpdated;

  HistoryPodcast({
    required this.podcast,
    required this.duration,
    required this.indexChapter,
    required this.dateUpdated,
  });

  factory HistoryPodcast.fromJson(Map<String, dynamic> json) {
    return HistoryPodcast(
        podcast: Podcast.fromJson(json['podcast']),
        duration: json['duration'] ?? 0,
        indexChapter: json['indexChapter'] ?? 0,
        dateUpdated: json['dateUpdated'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'podcast': podcast.toJson(),
      'duration': duration,
      'indexChapter': indexChapter,
      'dateUpdated': dateUpdated,
    };
  }
}
