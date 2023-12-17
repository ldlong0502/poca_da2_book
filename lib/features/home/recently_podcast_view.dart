import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/home_cubit.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/recently_play_cubit.dart';
import 'package:poca/features/home/dialog_play_history.dart';
import 'package:poca/features/home/title_see_all.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/screens/recently_see_all.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/resizable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../routes/app_routes.dart';
import '../../utils/navigator_custom.dart';
import '../../widgets/network_image_custom.dart';

class RecentlyPodcastView extends StatelessWidget {
  const RecentlyPodcastView({super.key});


  @override
  Widget build(BuildContext context) {
    context.read<RecentlyPlayCubit>().load();
    return BlocBuilder<RecentlyPlayCubit,int>(
      builder: (context, state) {
        final cubit = context.read<RecentlyPlayCubit>();
        if(state == 0 || cubit.listHistory.isEmpty) return Container();

        var list = cubit.listHistory;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleSeeAll(title: 'Recently Played', onSeeAll: () {
              NavigatorCustom.pushNewScreen(context, RecentlySeeAll(cubit:  cubit, title: 'Recently Played',), AppRoutes.recentlySeeAll);
            }),
            GridView.builder(
              shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20),
                  vertical: Resizable.padding(context, 10),

                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length >=4 ? 4 : list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: Resizable.size(context, 10),
                  mainAxisSpacing: Resizable.size(context, 10),

                ), itemBuilder: (context , index) {

                  var podcast = list[index].podcast;
                  var episode = list[index].podcast.episodesList[list[index].indexChapter];
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: () async {
                        final cubit = context.read<PlayerCubit>();
                        if( !cubit.checkPermissionBeforeListen(podcast, list[index].indexChapter)) {
                          return;
                        }
                        await showDialog(context: context, builder: (context ) {
                          return DialogPlayHistory(
                            onPlayAgain: () {
                              cubit.listen(podcast,list[index].indexChapter );
                              Navigator.pop(context);

                          }, onPlayContinue: (){
                            cubit.listen(podcast,list[index].indexChapter , list[index].duration );
                            Navigator.pop(context);
                          } , historyPodcast: list[index],);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 4,
                                child: LayoutBuilder(
                                  builder: (context , c) {
                                    return NetworkImageCustom(
                                      url: list[index].podcast.imageUrl,
                                      height: c.maxHeight,
                                      width: c.maxWidth,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                    );
                                  }
                                )),
                            Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: primaryColor.withOpacity(0.1)
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 15),
                                    vertical: Resizable.padding(context, 10)
                                  ),
                                  child: Column(
                                    children: [

                                      Expanded(
                                        child: Text(episode.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: Resizable.font(context, 14),
                                            color: primaryColor,
                                            fontWeight: FontWeight.w700
                                        ),),
                                      ),

                                      Expanded(
                                        child: Center(
                                          child: LinearPercentIndicator(
                                            padding: EdgeInsets.zero,
                                            lineHeight: 6.0,
                                            percent: list[index].duration / (episode.duration * 1000),
                                            barRadius: const Radius.circular(1000),
                                            backgroundColor: Colors.grey.shade400,
                                            progressColor: Colors.blue,
                                          ),
                                        ),

                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
            }),
            const SizedBox(height: 10,),
          ],
        );
      },
    );
  }
}


