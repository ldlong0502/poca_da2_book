import 'package:flutter_bloc/flutter_bloc.dart';

class HideItemCubit extends Cubit<bool> {
  HideItemCubit() : super(true);

  update() {
    emit(!state);
  }
}