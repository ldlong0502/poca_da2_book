import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/topic_detail_cubit.dart';
import 'package:poca/features/podcast/podcast_detail_view.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/utils/navigator_custom.dart';

import '../../configs/constants.dart';
import '../../screens/base_screen.dart';
import '../../utils/resizable.dart';
import '../../widgets/header_custom.dart';
import '../../widgets/loading_progress.dart';
import '../../widgets/network_image_custom.dart';
import 'empty_box.dart';

class TopicDetailView extends StatelessWidget {
  const TopicDetailView({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: '',
      child: BlocProvider(
        create: (context) => TopicDetailCubit(topic.id),
        child: BlocBuilder<TopicDetailCubit, int>(
          builder: (context, state) {
            if (state == 0) return const LoadingProgress();
            final cubit = context.read<TopicDetailCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    topic.name,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 24),
                        color: textColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: cubit.listPodcasts.isEmpty
                        ? const EmptyBox()
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing:
                                        Resizable.padding(context, 15),
                                    mainAxisSpacing:
                                        Resizable.padding(context, 10),
                                    childAspectRatio: 0.75),
                            itemCount: cubit.listPodcasts.length,
                            itemBuilder: (context, index) {
                              var podcast = cubit.listPodcasts[index];
                              return InkWell(
                                onTap: () {
                                  NavigatorCustom.pushNewScreen(
                                      context,
                                      PodcastDetailView(podcast: podcast),
                                      AppRoutes.podcastDetail);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: LayoutBuilder(
                                            builder: (context , c) {
                                              return NetworkImageCustom(
                                                  url: podcast.imageUrl,
                                                  width: c.maxWidth,
                                                  height: c.maxWidth,
                                                borderRadius: BorderRadius.circular(20),
                                              );
                                            }
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          podcast.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize:
                                                  Resizable.font(context, 22),
                                              color: textColor,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          podcast.host,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize:
                                                  Resizable.font(context, 18),
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )),
                              );
                            }))
              ],
            );
          },
        ),
      ),
    );
  }
}
