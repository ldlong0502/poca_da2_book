import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/models/history_podcast.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/local/history_podcast_provider.dart';
import 'package:poca/providers/preference_provider.dart';

class CloudService {
  CloudService._privateConstructor();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static final CloudService _instance = CloudService._privateConstructor();

  static CloudService get instance => _instance;

  Future<String> uploadImage(File imageFile, String imagePath) async {
    try {
      Reference storageReference = _storage.ref('poca/image/$imagePath.jpg');

      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {

      print("Error uploading image: $e");
      return '';
    }
  }
}
