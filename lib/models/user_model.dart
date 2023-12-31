import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:poca_book/utils/convert_utils.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String password; // Note: It's advisable to store hashed passwords instead of plaintext
  final String fullName;
  final DateTime dateOfBirth;
  final String imageUrl;
  final bool isAdmin;


  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.dateOfBirth,
    required this.imageUrl,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      fullName: json['fullName'] ?? '',
      dateOfBirth: DateFormat('dd-MM-yyyy').parse(json['dateOfBirth']),
      imageUrl: json['imageUrl'] ?? '',
      isAdmin: json['isAdmin']?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'dateOfBirth': ConvertUtils.convertDob(dateOfBirth),
      'imageUrl': imageUrl,
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? fullName,
    DateTime? dateOfBirth,
    String? imageUrl,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      imageUrl: imageUrl ?? this.imageUrl,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
