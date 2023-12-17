import 'package:flutter/cupertino.dart';

class Topic {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int v;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.v,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description']?? '',
      imageUrl: json['imageUrl']?? '',
      v: json['__v'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      '__v': v,
    };
  }
}
