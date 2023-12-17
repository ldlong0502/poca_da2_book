import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:poca/blocs/app_bar_audio_book_cubit.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/audio_book.dart';

import '../../blocs/mini_player_cubit.dart';
import '../../utils/resizable.dart';

class AppBarAudioBook extends StatelessWidget {
  const AppBarAudioBook({super.key, required this.audioBook});

  final AudioBook audioBook;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBarAudioBookCubit, int>(
    builder: (context, state) {
      final cubit = context.read<AppBarAudioBookCubit>();
      final miniPlayerCubit = context.read<MiniPlayerCubit>();
      cubit.scrollController.addListener(() {
        if(cubit.scrollController.offset > Resizable.height(context) * 0.4) {
          if(!cubit.isShowTitle) {
            cubit.changeShowTitle(true);

          }
          if(!cubit.isShowMaxButton) {
            cubit.changeShowMaxButton(true);
          }
        }
        else {
          if(cubit.isShowTitle) {
            cubit.changeShowTitle(false);

          }
          if(cubit.isShowMaxButton) {
            cubit.changeShowMaxButton(false);
          }
        }
      });
      return SliverAppBar(
        expandedHeight: Resizable.height(context) * 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: purpleColor,
        pinned: true,
        title: cubit.isShowTitle ?  Text(audioBook.title , style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: whiteColor
        ),): null,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25
                      ),
                      child: Hero(
                        tag: 'audio_book_${audioBook.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            audioBook.image,
                            fit: BoxFit.fill,
                            height: Resizable.height(context) * 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.menu_book, color: Colors.white,),
                            SizedBox(width: 10,),
                            Text('SÁCH NÓI' , style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: whiteColor
                            ),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        AutoSizeText(audioBook.title ,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                          fontSize: Resizable.font(context, 25)
                        ),),
                        Row(
                          children: [
                            AutoSizeText(audioBook.author , style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: whiteColor
                            ),),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        RatingBarIndicator(
                          rating: 4.5,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                          ),
                          unratedColor: Colors.blue,
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottom:  PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: (){
                if(miniPlayerCubit.currentAudioBook == null || miniPlayerCubit.currentAudioBook!.id != audioBook.id) {
                  miniPlayerCubit.listen(audioBook);
                }

              },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.blueAccent,
                        pinkColor
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(1, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: cubit.isShowMaxButton ? Resizable.width(context) * 0.9 : 200,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle_outline , size: 30, color: Colors.white,),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Nghe ngay',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      );
    },
);
  }
}