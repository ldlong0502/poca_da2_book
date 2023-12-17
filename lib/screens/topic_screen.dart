import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/topics/topic_detail_view.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/utils/navigator_custom.dart';

import '../configs/constants.dart';
import '../features/blocs/topic_cubit.dart';
import '../features/home/title_see_all.dart';
import '../utils/resizable.dart';
import '../widgets/header_custom.dart';
import '../widgets/loading_progress.dart';
import 'base_screen.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Topic',
      child: BlocProvider(
        create: (context) => TopicCubit(),
        child: BlocBuilder<TopicCubit, int>(
          builder: (context, state) {
            if (state == 0) return const LoadingProgress();
            final topicCubit = context.read<TopicCubit>();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontSize: Resizable.font(context, 24),
                          color: textColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: Resizable.padding(context, 15),
                          mainAxisSpacing: Resizable.padding(context, 10),
                          childAspectRatio: 1.8),
                      itemCount: topicCubit.listTopics.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            NavigatorCustom.pushNewScreen(
                                context,
                                TopicDetailView(
                                    topic: topicCubit.listTopics[index]),
                                AppRoutes.topicDetail);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: getRandomColor(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                topicCubit.listTopics[index].name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Resizable.font(context, 18)),
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color getRandomColor() {
    var listColor = <Color>[
      const Color(0xffFBBC05),
      const Color(0xff34A853),
      const Color(0xffB0B7D3),
      const Color(0xff977474),
      const Color(0xff96C1DA),
      const Color(0xffFB6666),
      const Color(0xffEADEB6),
      const Color(0xff8E4066),
    ];
    listColor.shuffle();
    return listColor.first;
  }
}
