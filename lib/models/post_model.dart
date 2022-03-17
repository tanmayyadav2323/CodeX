import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:code/config/paths.dart';
import 'package:code/models/user_model.dart';

class Post extends Equatable {
  final String? id;
  final String roomId;
  final User author;
  final String link;
  final String imageUrl;
  final String caption;
  final int likes;
  final DateTime date;

  const Post({
    this.id,
    required this.roomId,
    required this.author,
    required this.link,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        author,
        imageUrl,
        caption,
        likes,
        link,
        roomId,
        date,
      ];

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'imageUrl': imageUrl,
      'roomId': roomId,
      'caption': caption,
      'likes': likes,
      'link': link,
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<Post> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final authorRef = data['author'] as DocumentReference;
    final authorDoc = await authorRef.get();
    return Post(
      id: doc.id,
      author: User.fromDocument(authorDoc),
      roomId: doc['roomId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      caption: data['caption'] ?? '',
      link: data['link'] ?? '',
      likes: (data['likes'] ?? 0).toInt(),
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Post copyWith({
    String? id,
    String? roomId,
    User? author,
    String? link,
    String? imageUrl,
    String? caption,
    int? likes,
    DateTime? date,
  }) {
    return Post(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      author: author ?? this.author,
      link: link ?? this.link,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      date: date ?? this.date,
    );
  }
}
