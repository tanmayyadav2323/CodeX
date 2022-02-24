import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:code/models/user_model.dart';

class PrivateChat {
  final String? id;
  final List<dynamic>? memberIds;
  final Timestamp? recentTimestamp;
  final dynamic readStatus;
  final String? recentSender;
  final String? imageUrl;
  final String? name;
  final String? linkedIn;
  final String? gitHub;
  final String? skills;

  PrivateChat({
    this.id,
    this.memberIds,
    this.recentTimestamp,
    this.readStatus,
    this.recentSender,
    this.imageUrl,
    this.name,
    this.linkedIn,
    this.gitHub,
    this.skills,
  });

  List<Object> get props => [
        id!,
        memberIds!,
        recentTimestamp!,
        readStatus,
        recentSender!,
        imageUrl!,
        name!,
        linkedIn!,
        gitHub!,
        skills!,
      ];

  static Future<PrivateChat?> fromDoc(DocumentSnapshot doc, User user) async {
    final data = doc.data() as Map<String, dynamic>;
    return PrivateChat(
      id: doc.id,
      recentSender: data['recentSender'] ?? '',
      recentTimestamp: data['recentTimestamp'] ?? '',
      memberIds: data['memberIds'] ?? '',
      readStatus: data['readStatus'] ?? '',
      name: user.name,
      gitHub: user.github,
      imageUrl: user.profileImageUrl,
      linkedIn: user.linkedIn,
      skills: user.skills,
    );
  }

  PrivateChat copyWith({
    String? id,
    List<dynamic>? memberIds,
    Timestamp? recentTimestamp,
    dynamic readStatus,
    String? recentSender,
    String? imageUrl,
    String? name,
    String? linkedIn,
    String? gitHub,
    String? skills,
  }) {
    return PrivateChat(
      id: id ?? this.id,
      memberIds: memberIds ?? this.memberIds,
      recentTimestamp: recentTimestamp ?? this.recentTimestamp,
      readStatus: readStatus ?? this.readStatus,
      recentSender: recentSender ?? this.recentSender,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      linkedIn: linkedIn ?? this.linkedIn,
      gitHub: gitHub ?? this.gitHub,
      skills: skills ?? this.skills,
    );
  }
}
