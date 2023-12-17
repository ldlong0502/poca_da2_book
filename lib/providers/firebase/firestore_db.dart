import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/models/mp3.dart';
import 'package:poca/models/user_model.dart';

import '../../models/comment.dart';
import '../../models/ebook.dart';

class FireStoreDb {
  FireStoreDb._privateConstructor();

  static final FireStoreDb _instance = FireStoreDb._privateConstructor();

  static FireStoreDb get instance => _instance;

  final db = FirebaseFirestore.instance;

  Future<List<Ebook>> getTop10EbooksByView() async {
    final snapshot = await db
        .collection("ebook")
        .orderBy('view', descending: true)
        .limit(10)
        .get();
    return snapshot.docs.map((e) => Ebook.fromJson(e.data())).toList();
  }
  Future<UserModel?> getUser(int userId) async {
    final snapshot =
    await db.collection("user").where('user_id', isEqualTo: userId).get();
    return snapshot.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;
  }
  Future<List<String>> getGenre(List<int> listIdGenre) async {
    final snapshot =
        await db.collection("genre").where('id', whereIn: listIdGenre).get();
    if(snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => e.data()['name'] as String).toList();
  }
  Future<List<Mp3File>> getMp3(int idAudioBook) async {
    final snapshot =
    await db.collection("mp3").where('audio_book_id', isEqualTo: idAudioBook).orderBy('id').get();
    if(snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) {
      return  Mp3File.fromJson(e.data());
    }).toList();
  }
  Future<List<AudioBook>> getTop5AudiobooksByView() async {
    final snapshot = await db
        .collection("audio_book")
        .orderBy('listen', descending: true)
        .limit(5)
        .get();
    final audioBooks = await Future.wait(snapshot.docs.map((e) async {
      final listGenreId = List<int>.from(e.data()['genre'] as List);
      final genre = await getGenre(listGenreId);
      final mp3 = await getMp3(e.data()['id'] as int);
      return AudioBook.fromJson(e.data(), genre , mp3);
    }).toList());

    return audioBooks;
  }

  Future<List<Comment>> getAllComments(int bookId, String type) async {
    final snapshot = await db
        .collection("comment")
        .where('book_id', isEqualTo: bookId)
        .where('type', isEqualTo: type)
        .orderBy('time', descending: true)
        .get();
    if(snapshot.docs.isEmpty) return [];
    return snapshot.docs.map((e) => Comment.fromJson(e.data())).toList();
  }
}
