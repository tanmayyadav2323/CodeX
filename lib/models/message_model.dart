import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final String? senderId;
  final String? text;
  final String? imageUrl;
  final bool isLiked;
  final Timestamp? timestamp;

  Message({
    this.id,
    this.senderId,
    this.isLiked = false,
    this.text,
    this.imageUrl,
    this.timestamp,
  });

  List<Object> get props => [
        id!,
        senderId!,
        isLiked,
        text!,
        imageUrl!,
        timestamp!,
      ];

  static Future<Message> fromDoc(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      senderId: data['senderId'] ?? "",
      text: data['text'] ?? "",
      imageUrl: data['imageUrl'],
      isLiked: data['isLiked'],
      timestamp: data['timestamp'] as Timestamp,
    );
  }
}
