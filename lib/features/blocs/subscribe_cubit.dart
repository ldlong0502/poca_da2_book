import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/user_model.dart';

import '../../providers/api/api_podcast.dart';

class SubscribeCubit extends Cubit<int> {
  SubscribeCubit() : super(0);
  List<Podcast> listPodcast = [];

  bool isGrid = true;

  updateView() {
    isGrid = !isGrid;
    emit(state+1);
  }
  load(UserModel user) async {
     listPodcast = await ApiPodcast.instance.getPodcastSubscribeByUserId(user.id);
    emit(state + 1);
  }
}
