import 'package:poca/models/episode.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';

class Podcast {
  final String id;
  final String title;
  final String description;
  final String host;
  final int publishDate;
  final String imageUrl;
  final List<Topic> topicsList;
  final List<Episode> episodesList;
  final List<UserModel> subscribesList;
  final List<UserModel> favoritesList;
  final UserModel? publishUser;

  Podcast(
      { required this.id,
        required this.title,
        required this.description,
        required this.topicsList,
        required this.host,
        required this.episodesList,
        required this.publishDate,
        required this.subscribesList,
        required this.favoritesList,
        required this.imageUrl,
        this.publishUser,
       });
  Podcast copyWith({
    String? id,
    String? title,
    String? description,
    String? host,
    int? publishDate,
    String? imageUrl,
    List<Topic>? topicsList,
    List<Episode>? episodesList,
    List<UserModel>? subscribesList,
    List<UserModel>? favoritesList,
    UserModel? publishUser,
  }) {
    return Podcast(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      host: host ?? this.host,
      publishDate: publishDate ?? this.publishDate,
      imageUrl: imageUrl ?? this.imageUrl,
      topicsList: topicsList ?? this.topicsList,
      episodesList: episodesList ?? this.episodesList,
      subscribesList: subscribesList ?? this.subscribesList,
      favoritesList: favoritesList ?? this.favoritesList,
      publishUser: publishUser ?? this.publishUser,
    );
  }
  factory Podcast.fromJson(Map<String, dynamic> json) {
    var topics = <Topic>[];
    if (json['topicsList'] != null) {
      json['topicsList'].forEach((v) {
        topics.add(Topic.fromJson(v));
      });
    }
    var episodes = <Episode>[];
    if (json['episodesList'] != null) {
      json['episodesList'].forEach((v) {
        episodes.add(Episode.fromJson(v));
      });
    }
    var subscribes = <UserModel>[];
    if (json['subscribesList'] != null) {
      json['subscribesList'].forEach((v) {
        subscribes.add(UserModel.fromJson(v));
      });
    }
    var favorites = <UserModel>[];
    if (json['favoritesList'] != null) {
      json['favoritesList'].forEach((v) {
        favorites.add(UserModel.fromJson(v));
      });
    }
    return Podcast(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description']?? '',
      host: json['host']?? '',
      topicsList: topics,
      publishDate: json['publishDate']?? 0,
      episodesList: episodes,
      imageUrl: json['imageUrl']?? '',
      subscribesList: subscribes,
      favoritesList: favorites,
      publishUser: json['publishUser'] == null ? null : UserModel.fromJson(json['publishUser']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'host': host,
      'audioFile': publishUser,
      'publishDate': publishDate,
      'topicsList': topicsList.map((v) => v.toJson()).toList(),
      'episodesList': episodesList.map((v) => v.toJson()).toList(),
      'subscribesList': subscribesList.map((v) => v.toJson()).toList(),
      'favoritesList': favoritesList.map((v) => v.toJson()).toList(),
      'imageUrl': imageUrl,
    };
  }
}