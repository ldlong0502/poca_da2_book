import 'package:flutter/material.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../configs/constants.dart';
import '../../routes/app_routes.dart';
import '../../utils/navigator_custom.dart';
import '../podcast/podcast_detail_view.dart';

class ItemSearch extends StatelessWidget {
  const ItemSearch({super.key, required this.isHistory, required this.podcast});

  final bool isHistory;
  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorCustom.pushNewScreen(context,
            PodcastDetailView(podcast: podcast), AppRoutes.podcastDetail);
      },
      child: Container(
        height: Resizable.size(context, 70),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            NetworkImageCustom(
              url: podcast.imageUrl,
              borderRadius: BorderRadius.circular(20),
              height: Resizable.size(context, 70),
              width: Resizable.size(context, 70),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  podcast.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 18),
                      color: textColor,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  podcast.host,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600),
                ),
              ],
            )),
            SizedBox(
              width: Resizable.size(context, 50),
              child: isHistory
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: secondaryColor,
                      ))
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
