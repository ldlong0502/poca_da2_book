import 'package:flutter/cupertino.dart';

class Mp3File {
  final int id;
  final String title;
  final String url;
  final int audioBookId;

  Mp3File({
    required this.id,
    required this.title,
    required this.url,
    required this.audioBookId,
  });

  factory Mp3File.fromJson(Map<String, dynamic> json) {
    return Mp3File(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        url: json['url'] ?? '',
        audioBookId: json['audio_book_id'] ?? 0);
  }
}
