import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarAudioBookCubit extends Cubit<int> {
  AppBarAudioBookCubit() : super(0);

  bool isShowTitle = false;
  bool isShowMaxButton = false;
  final ScrollController scrollController = ScrollController();


  void changeShowTitle(bool value){
    isShowTitle = value;
    emit(state+1);
  }
  void changeShowMaxButton(bool value){
    isShowMaxButton = value;
    emit(state+1);
  }

}
