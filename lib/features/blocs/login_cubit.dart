import 'package:flutter_bloc/flutter_bloc.dart';
enum LoginStatus {
  start, loading, failed , success
}
class LoginCubit extends Cubit<LoginStatus> {
  LoginCubit() : super(LoginStatus.start);

  update(LoginStatus value) {
    if(isClosed) return;
    emit(value);
  }
}
