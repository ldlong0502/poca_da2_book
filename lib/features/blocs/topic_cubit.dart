import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';

class TopicCubit extends Cubit<int> {
  TopicCubit() : super(0) {
    load();
  }
  List<Topic> listTopics = [];
  load() async {
    listTopics = await ApiTopic.instance.getListTopics();
    if(isClosed) return;
    emit(state+1);
  }
}
