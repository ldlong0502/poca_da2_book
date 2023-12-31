import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poca_book/models/user_model.dart';
import 'package:poca_book/providers/api/api_provider.dart';
import 'package:poca_book/providers/preference_provider.dart';
import 'package:poca_book/providers/user/user_provider.dart';
import 'package:poca_book/utils/custom_toast.dart';

import '../../routes/app_routes.dart';

class FirebaseAuthentication {
  FirebaseAuthentication._privateConstructor();

  static final FirebaseAuthentication _instance = FirebaseAuthentication._privateConstructor();

  static FirebaseAuthentication get instance => _instance;
  final db = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    final snapshot =
    await db.collection("user").where('email', isEqualTo: email ).where('password', isEqualTo: password ).get();
    var model = snapshot.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;
    if(model != null) {
      await PreferenceProvider.instance.saveJsonToPrefs( model.toJson(), 'user');
    }
    return model;

  }
  Future<bool> signUp(String email, String fullName , String username, String dob, String password) async {

    debugPrint(dob);
    var response = await ApiProvider().post('/auth/register', data:  {
      "username": username,
      "email": email,
      "password": password,
      "fullName": fullName,
      "dateOfBirth": dob
    });
    debugPrint(response.toString());
    if(response == null) return false;
    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logOut(BuildContext context) async {
    await PreferenceProvider.instance.removeJsonToPref('access_token');
    await PreferenceProvider.instance.removeJsonToPref('refresh_token');
    await PreferenceProvider.instance.removeJsonToPref('user');
    if(context.mounted){
      CustomToast.showBottomToast(context, 'Log out successfully!');
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.splash, (route) => false,);
    }
    return true;


  }


}