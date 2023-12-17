import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/home_cubit.dart';
import 'package:poca/features/home/title_see_all.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../configs/constants.dart';
import '../../routes/app_routes.dart';
import '../../utils/navigator_custom.dart';
import '../../utils/resizable.dart';
import '../blocs/player_cubit.dart';
import '../topics/topic_detail_view.dart';

class TopicSuggest extends StatelessWidget {
  const TopicSuggest({super.key, required this.homeCubit});

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSeeAll(title: 'Suggest topics', onSeeAll: () {
          final cubit = context.read<PlayerCubit>();
          cubit.persistentTabController.jumpToTab(1);
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
            children: homeCubit.listTopics.map((e) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: (){
                    NavigatorCustom.pushNewScreen(
                        context,
                        TopicDetailView(
                            topic: e),
                        AppRoutes.topicDetail);
                  },
                  child: SizedBox(
                    width: Resizable.size(context, 150),
                    child: Column(

                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: NetworkImageCustom(
                              url: e.imageUrl,
                              height: Resizable.size(context, 150),
                              width: Resizable.size(context, 150),
                              borderRadius: BorderRadius.circular(20),
                            )),
                        const SizedBox(height: 5,),
                        Expanded(
                          child: Text(
                            e.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
      ],
    );
  }
}
