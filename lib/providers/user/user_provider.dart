import 'package:firebase_auth/firebase_auth.dart';
import 'package:poca/models/user_model.dart';

class UserProvider {
  UserProvider._privateConstructor();

  static final UserProvider _instance = UserProvider._privateConstructor();

  static UserProvider get instance => _instance;


  UserModel? _userModel;

  UserModel? get currentUser => _userModel;

  setUser(UserModel value) {
    _userModel = value;
  }
}