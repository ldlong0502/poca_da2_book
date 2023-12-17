import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/providers/firebase/firestore_db.dart';

import '../models/comment.dart';
import '../models/ebook.dart';
import '../models/user_model.dart';

class FireBaseProvider {
  FireBaseProvider._privateConstructor();

  static final FireBaseProvider _instance = FireBaseProvider._privateConstructor();

  static FireBaseProvider get instance => _instance;

  final db = FirebaseFirestore.instance;
  Future addJsonToFireBase() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final jsonData = json.decode(jsonString);
    for (final data in jsonData) {
      try{
        await db.collection('mp3').doc('audio_book_4_mp3_${data['id']}').set(data);
      }
      catch ( e) {
        debugPrint('=>>>>>error: $e');
      }
    }
  }
  Future<UserModel?> getUser(int userId) async {
    return await FireStoreDb.instance.getUser(userId);
  }
  Future<List<Ebook>> getTop10EbooksByView() async {
    return await FireStoreDb.instance.getTop10EbooksByView();
  }
  Future<List<AudioBook>> getTop5AudiobooksByView() async {
    return await FireStoreDb.instance.getTop5AudiobooksByView();
  }

  Future<List<Comment>> getAllComments(int bookId , String type) async {
    return await FireStoreDb.instance.getAllComments(bookId, type);
  }
}