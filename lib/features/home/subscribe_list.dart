import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/subscribe_cubit.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/features/home/title_see_all.dart';
import 'package:poca/features/podcast/podcast_detail_view.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/models/user_model.dart';


import '../../configs/constants.dart';
import '../../routes/app_routes.dart';
import '../../screens/subscribe_see_all.dart';
import '../../utils/navigator_custom.dart';
import '../../utils/resizable.dart';
import '../../widgets/network_image_custom.dart';

class SubscribeList extends StatelessWidget {
  const SubscribeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {

        if(user != null) {
          context.read<SubscribeCubit>().load(user);
        }
        return BlocBuilder<SubscribeCubit, int>(
          builder: (context, list) {
            if(list == 0) return Container();
            final cubit = context.read<SubscribeCubit>();

            if(cubit.listPodcast.isEmpty) return Container();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleSeeAll(title: 'Your subscriptions', onSeeAll: () {
                  NavigatorCustom.pushNewScreen(context, SubscriptionSeeAll(cubit:  cubit, title: 'Your subscriptions',), AppRoutes.subsSeeAll);
                }),
                SizedBox(
                  height: 220,
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        left: 20,
                        top: 10
                    ),
                    scrollDirection: Axis.horizontal,
                    children: cubit.listPodcast.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          onTap: (){
                            NavigatorCustom.pushNewScreen(
                                context,
                                PodcastDetailView(
                                    podcast: e),
                                AppRoutes.podcastDetail);
                          },
                          child: SizedBox(
                            width:  Resizable.size(context, 150),
                            child: Column(
                              children: [
                                NetworkImageCustom(
                                  url: e.imageUrl,
                                  height: Resizable.size(context, 150),
                                  width: Resizable.size(context, 150),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                const SizedBox(height: 5,),
                                Expanded(
                                  child: Text(
                                    e.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Resizable.font(context, 20),
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            );
          },
        );
      },
    );
  }
}
