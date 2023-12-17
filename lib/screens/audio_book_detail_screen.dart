import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/blocs/app_bar_audio_book_cubit.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/utils/resizable.dart';

import '../features/audio_book/app_bar_audio_book.dart';
import '../features/audio_book/audio_catalogue.dart';
import '../widgets/list_comment.dart';

class AudioBookDetailScreen extends StatelessWidget {
  const AudioBookDetailScreen({super.key, required this.audioBook});

  final AudioBook audioBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AppBarAudioBookCubit(),
        child: BlocBuilder<AppBarAudioBookCubit, int>(
          builder: (context, state) {
            final cubit = context.read<AppBarAudioBookCubit>();
            return CustomScrollView(
              controller: cubit.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppBarAudioBook(audioBook: audioBook,),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        getTitle(context, 'Giới thiệu về truyện'),
                        const SizedBox(height: 20,),
                        ExpandableText(
                          audioBook.description + audioBook.description + audioBook.description ,
                          expandText: 'Xem thêm',
                          collapseText: 'Hiển thị ít hơn',
                          maxLines: 6,
                          linkStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Resizable.font(context, 15),
                              color: Colors.black
                          ),
                          linkColor: purpleColor,
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          height: Resizable.size(context, 50),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            primary: true,
                            children: audioBook.genre.map((e) => Card(
                              color: Colors.grey.shade300,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(e , style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: purpleColor
                                ),),
                              ),
                            )).toList(),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        const Divider(
                          height: 2,
                          thickness: 1,
                        ),
                        const SizedBox(height: 20,),
                        getTitle(context, 'Bạn đọc nói gì'),
                        ListComment(bookId: audioBook.id, type: 'audio_book'),
                        const Divider(
                          height: 2,
                          thickness: 1,
                        ),
                        const SizedBox(height: 20,),
                        getTitle(context, 'Mục lục'),
                        AudioCatalogue(audioBook: audioBook,),
                        const SizedBox(height: 150,),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
  getTitle(BuildContext context, String title) {
    return Text(title , style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Resizable.font(context, 20),
        color: Colors.black

    ),);
  }
}
