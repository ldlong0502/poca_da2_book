class Comment {
  final int bookId;
  final int userId;
  final double rate;
  final int time;
  final String type;
  final String content;
  final String title;
  Comment({
    required this.bookId,
    required this.userId,
    required this.rate,
    required this.time,
    required this.type,
    required this.content,
    required this.title,
  });

  factory Comment.fromJson(Map<dynamic, dynamic> json) {
    return Comment(
        bookId: json['book_id'],
        userId: json['user_id'],
        rate: double.parse(json['rate'].toString()),
        time: json['time'],
        type: json['type'],
        content: json['content'],
        title: json['title']);
  }
}
