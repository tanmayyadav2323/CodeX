import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String? profileImageUrl;
  final String name;
  final String skills;
  final String linkedIn;
  final String github;

  const User({
    required this.id,
    required this.username,
    this.profileImageUrl,
    required this.name,
    required this.skills,
    required this.linkedIn,
    required this.github,
  });

  User copyWith({
    String? id,
    String? username,
    String? profileImageUrl,
    String? name,
    String? skills,
    String? linkedIn,
    String? github,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      name: name ?? this.name,
      skills: skills ?? this.skills,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
    );
  }

  static const empty = User(
      id: '',
      username: '',
      profileImageUrl: null,
      name: '',
      skills: '',
      linkedIn: '',
      github: '');

  @override
  List<Object> get props => [
        id,
        username,
        profileImageUrl!,
        name,
        skills,
        linkedIn,
        github,
      ];

  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'profileImageUrl': profileImageUrl,
      'name': name,
      'skills': skills,
      'linkedIn': linkedIn,
      'github': github,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      name: data['name'] ?? '',
      skills: data['skills'] ?? '',
      linkedIn: data['linkedIn'] ?? '',
      github: data['github'] ?? '',
    );
  }
}
