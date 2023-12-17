
import 'mp3.dart';

class AudioBook {
  final int id;
  final String title;
  final String image;
  final String author;
  final String year;
  final int createdAt;
  final String publisher;
  final int listen;
  final List<String> genre;
  final String description;
  final List<Mp3File> listMp3;
  AudioBook({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.year,
    required this.createdAt,
    required this.publisher,
    required this.listen,
    required this.genre,
    required this.description,
    required this.listMp3,
  });

  factory AudioBook.fromJson(Map<dynamic, dynamic> json , List<String> genre ,  List<Mp3File> mp3) {
    return AudioBook(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      author: json['author'] as String,
      year: json['year'] as String,
      createdAt: json['createdAt'] as int,
      publisher: json['publisher'] as String,
      listen: json['listen'] as int,
      genre: genre,
      listMp3: mp3,
      description: json['description'] as String,
    );
  }
}
