// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'mp3.dart';

class Ebook {
  final int id;
  final String title;
  final String image;
  final String author;
  final String year;
  final int createdAt;
  final String publisher;
  final int view;
  final List<int> genre;
  final String pages;
  final String description;
  final String epub;

  Ebook({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.year,
    required this.createdAt,
    required this.publisher,
    required this.view,
    required this.genre,
    required this.pages,
    required this.description,
    required this.epub,
  });

  factory Ebook.fromJson(Map<dynamic, dynamic> json) {
    return Ebook(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      author: json['author'] as String,
      year: json['year'] as String,
      createdAt: json['createdAt'] as int,
      publisher: json['publisher'] as String,
      view: json['view'] as int,
      genre: List<int>.from(json['genre'] as List),
      pages: json['pages'] as String,
      description: json['description'] as String,
      epub: json['epub'] as String,
    );
  }
}