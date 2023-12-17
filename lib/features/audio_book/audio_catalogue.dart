import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/models/mp3.dart';
import 'package:poca/utils/resizable.dart';

import '../../blocs/hide_item_cubit.dart';

class AudioCatalogue extends StatelessWidget {
  const AudioCatalogue({super.key, required this.audioBook});

  final AudioBook audioBook;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HideItemCubit(),
      child: BlocBuilder<HideItemCubit, bool>(
        builder: (context, state) {
          final cubit = context.read<HideItemCubit>();
          List<Mp3File> listMp3 = [];
          if (state) {
            listMp3 = audioBook.listMp3.take(2).toList();
          } else {
            listMp3 = audioBook.listMp3;
          }
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...listMp3.map((e) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 10)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Icon(
                        Icons.headset_rounded,
                        color: Colors.grey.shade500,
                        size: 30,
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chương ${e.id}'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 13),
                                  color: pinkColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(e.title,
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 15),
                                    color: purpleColor,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const Expanded(
                          child: Icon(
                        Icons.play_circle,
                        color: pinkColor,
                        size: 30,
                      ))
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(
                height: 10,
              ),
              if(audioBook.listMp3.length > 2)
              GestureDetector(
                onTap: () {
                  cubit.update();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state
                          ? 'Hiển thị tất cả ${audioBook.listMp3.length} chương'
                          : 'Hiển thị ít hơn',
                      style: TextStyle(
                          fontSize: Resizable.font(context, 13),
                          color: pinkColor,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(state ?  Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_up_outlined , color: pinkColor, size: 20,)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


