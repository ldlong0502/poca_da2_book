import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:poca/features/home/subscribe_list.dart';
import 'package:poca/features/home/title_see_all.dart';
import 'package:poca/features/home/topic_suggest.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../configs/app_configs.dart';
import '../features/blocs/home_cubit.dart';
import '../features/home/new_release_widget.dart';
import '../features/home/recently_podcast_view.dart';
import '../widgets/header_custom.dart';
import '../widgets/custom_mini_player.dart';
import 'base_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title:  'Good morning,',
      child: BlocProvider(
        create: (context) => HomeCubit(),
        child: BlocBuilder<HomeCubit, int>(
          builder: (context, state) {
            if(state == 0) return const LoadingProgress();
            final homeCubit = context.read<HomeCubit>();
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const SubscribeList(),
                  TopicSuggest(homeCubit: homeCubit),
                  NewReleaseWidget(homeCubit: homeCubit,),
                  const SizedBox(height: 20,),
                  const RecentlyPodcastView(),
                  const SizedBox(height: 60,),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
