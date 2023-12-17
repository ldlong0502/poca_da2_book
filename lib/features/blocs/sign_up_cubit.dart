import 'package:flutter_bloc/flutter_bloc.dart';
enum SignUpStatus {
  start, loading, failed , success
}
class SignUpCubit extends Cubit<SignUpStatus> {
  SignUpCubit() : super(SignUpStatus.start);

  update(SignUpStatus value) {
    if(isClosed) return;
    emit(value);
  }
}
