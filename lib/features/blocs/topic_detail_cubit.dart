import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';

class TopicDetailCubit extends Cubit<int> {
  TopicDetailCubit(this.topicId) : super(0) {
    load();
  }
  final String topicId;
  List<Podcast> listPodcasts = [];
  load() async {
    listPodcasts = await ApiPodcast.instance.getListPodcastByTopicId(topicId);
    if(isClosed) return;
    emit(state+1);
  }
}
