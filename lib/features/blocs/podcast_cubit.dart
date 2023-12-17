import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/utils/custom_toast.dart';

import '../../models/user_model.dart';
import '../../providers/api/api_espisode.dart';

class PodcastCubit extends Cubit<int> {
  PodcastCubit(this.podcastId) : super(0);

  final String podcastId;
  Podcast? podcast;
  bool isShowMaxButton = false;
  final ScrollController scrollController = ScrollController();

  void changeShowMaxButton(bool value){
    isShowMaxButton = value;
    emit(state+1);
  }
  load()  async {
    emit(0);
    podcast = await ApiPodcast.instance.getPodcastById(podcastId);
    if(podcast == null) {
      return;
    }
    emit(state + 1);
  }

  updateListens(BuildContext context,  int value) async {
    var playCubit = context.read<PlayerCubit>();
    if(playCubit.currentPodcast != null && podcast!.id == playCubit.currentPodcast!.id &&  value == playCubit.indexChapter) {
      return;
    }
    await ApiEpisode.instance.increaseListens( podcast!.id, podcast!.episodesList[value].id);
    var episodes = [...podcast!.episodesList];
    episodes[value] = episodes[value].copyWith(listens: episodes[value].listens + 1);
    podcast = podcast!.copyWith(
      episodesList: episodes
    );

    emit(state + 1 );
  }

   updateFav(BuildContext context , UserModel user) async {
     var isFav = podcast!.favoritesList
         .map((e) => e.id)
         .contains(user.id);
     if(isFav) {
       var fav = [...podcast!.favoritesList];
       fav.removeWhere((element) => element.id == user.id);
       podcast = podcast!.copyWith(
         favoritesList: fav
       );
       await ApiPodcast.instance.addOrRemoveUserFavorite(podcast!.id, user.id, 'remove');

       if(context.mounted) {
         CustomToast.showBottomToast(context, 'Removed from favorites list' , ToastGravity.TOP);
       }


     }
     else {
       var fav = [...podcast!.favoritesList];
       fav.add(user);
       podcast = podcast!.copyWith(
           favoritesList: fav
       );
       await ApiPodcast.instance.addOrRemoveUserFavorite(podcast!.id, user.id, 'add');
       if(context.mounted) {
         CustomToast.showBottomToast(context, 'Added to favorites list' , ToastGravity.TOP);
       }

     }
     emit(state + 1);
   }

  updateSubscribes(BuildContext context , UserModel user) async {
    var isFav = podcast!.subscribesList
        .map((e) => e.id)
        .contains(user.id);
    if(isFav) {
      var fav = [...podcast!.subscribesList];
      fav.removeWhere((element) => element.id == user.id);
      podcast = podcast!.copyWith(
          subscribesList: fav
      );
      var res = await ApiPodcast.instance.addOrRemoveUserSubscribe(podcast!.id, user.id, 'remove');
      debugPrint('=>>>>>>>>>>>$res');
      if(context.mounted) {
        CustomToast.showBottomToast(context, 'Unsubscribes to this podcast' , ToastGravity.TOP);
      }


    }
    else {
      var fav = [...podcast!.subscribesList];
      fav.add(user);
      podcast = podcast!.copyWith(
          subscribesList: fav
      );
      await ApiPodcast.instance.addOrRemoveUserSubscribe(podcast!.id, user.id, 'add');
      if(context.mounted) {
        CustomToast.showBottomToast(context, 'You have already subscribed this podcast' , ToastGravity.TOP);
      }

    }
    emit(state + 1);
  }
}
