import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String? id;
  final String name;
  final String bio;
  final String imageUrl;
  final String creatorId;
  final String creatorName;
  final Timestamp? creationDate;
  final int numofMembers;
  final List<dynamic> memberIds;
  final Timestamp? recentTimestamp;
  final dynamic readStatus;
  final String? recentSender;
  final String? recentMessage;
  final Map<String, dynamic>? memberInfo;

  const Room({
    this.id,
    required this.name,
    required this.bio,
    required this.imageUrl,
    required this.creatorId,
    required this.creatorName,
    this.creationDate,
    required this.numofMembers,
    required this.memberIds,
    this.recentTimestamp,
    this.readStatus,
    this.recentSender,
    this.recentMessage,
    this.memberInfo,
  });

  static const empty = Room(
    name: '',
    bio: '',
    imageUrl: '',
    memberIds: [],
    numofMembers: 0,
    creatorId: '',
    creatorName: '',
    id: '',
  );

  Room copyWith({
    String? id,
    String? name,
    String? bio,
    String? imageUrl,
    String? creatorId,
    String? creatorName,
    Timestamp? creationDate,
    int? numofMembers,
    List<dynamic>? memberIds,
    Timestamp? recentTimestamp,
    dynamic readStatus,
    String? recentSender,
    String? recentMessage,
    Map<String, dynamic>? memberInfo,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creationDate: creationDate ?? this.creationDate,
      numofMembers: numofMembers ?? this.numofMembers,
      memberIds: memberIds ?? this.memberIds,
      recentTimestamp: recentTimestamp ?? this.recentTimestamp,
      readStatus: readStatus ?? this.readStatus,
      recentSender: recentSender ?? this.recentSender,
      recentMessage: recentMessage ?? this.recentMessage,
      memberInfo: memberInfo ?? this.memberInfo,
    );
  }

  @override
  List<Object?> get props =>
      [name, bio, imageUrl, numofMembers, creatorId, creatorName, creationDate];

  factory Room.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Room(
      id: doc.id,
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      imageUrl: data['roomImage'] ?? '',
      numofMembers: data['numofMembers'] ?? 1,
      readStatus: data['readStatus'] ?? '',
      recentSender: data['recentSender'] ?? '',
      recentTimestamp: data['recentTimestamp'] ?? '',
      memberIds: data['memberIds'] ?? '',
      memberInfo: data['memberInfo'] ?? '',
      recentMessage: data['recentMessage'] ?? '',
      creatorId: data['creatorId'] ?? '',
      creatorName: data['creatorName'] ?? '',
      creationDate: data['creationDate'] ?? '',
    );
  }
}
