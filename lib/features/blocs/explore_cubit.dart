import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/providers/preference_provider.dart';

class ExploreCubit extends Cubit<int> {
  ExploreCubit() : super(0) {
    load();
  }
  List<Podcast> listPodcast = [];
  Episode? latestEpisode;
  Podcast? podcastContainLatestEpisode;
  bool isFocus = false;
  bool isSearching = false;
  load() async {
    listPodcast = await getHistorySearch();
    if(isClosed) return;
    emit(state+1);
  }

  Future<List<Podcast>> getHistorySearch() async {
    var json = await PreferenceProvider.instance.getJsonFromPrefs('history_search');
    if(json == null) return [];
    List<Podcast> podcasts =
    (json as List).map((e) => Podcast.fromJson(e)).toList();
    return podcasts;
  }

  updateFocus(bool value) {
    isFocus = value;
    emit(state+1);
  }
  searchPodcasts(String searchText) async {
    if(searchText.isEmpty) {
      isSearching = false;
      listPodcast = await getHistorySearch();
    }
    else {
      isSearching = true;
      listPodcast =  await ApiPodcast.instance.searchPodcast(searchText);
    }
    emit(state+1);
  }
}
