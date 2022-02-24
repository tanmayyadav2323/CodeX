import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/config/paths.dart';
import 'package:code/models/chat_model.dart';
import 'package:code/models/message_model.dart';
import 'package:code/models/private_chat_model.dart';
import 'package:code/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';

import 'package:code/models/user_model.dart';
import 'package:code/repositories/chat/base_chat_repository.dart';

class ChatRepository extends BaseChatRepository {
  final FirebaseFirestore _firebaseFirestore;
  final StorageRepository _storageRepository = StorageRepository();

  ChatRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<List<User>> searchUser(String currentUserId, String query) async {
    QuerySnapshot usernameSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .get();
    List<User> users = [];
    for (var doc in usernameSnap.docs) {
      User user = User.fromDocument(doc);
      if (user.id != currentUserId) users.add(user);
    }
    return users;
  }

  Future<bool> privateChat(String currentUserId, String userId) async {
    List<String> memberIds = [currentUserId, userId];
    Map<String, dynamic> readStatus = {};

    readStatus[currentUserId] = false;
    readStatus[userId] = false;

    await _firebaseFirestore.collection('privateChats').add(
      {
        'recentMessage': 'Chat created',
        'recentSender': '',
        'recentTimestamp': Timestamp.now(),
        'memberIds': memberIds,
        'readStatus': readStatus,
      },
    );
    return true;
  }

  Stream<List<Future<PrivateChat?>>> getPrivateChats(String userId) {
    return _firebaseFirestore
        .collection('privateChats')
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) async {
            final data = doc.data();
            String otherUserId;
            if (data['memberIds'][0] == userId) {
              otherUserId = data['memberIds'][1];
            } else {
              otherUserId = data['memberIds'][0];
            }
            final user = await getUserWithId(userId: otherUserId);
            return PrivateChat.fromDoc(doc, user);
          }).toList(),
        );
  }

  @override
  Future<bool> createChat(
      BuildContext context, String name, File file, List<String> users) async {
    String imageUrl =
        await _storageRepository.uploadChatImage(url: null, imageFile: file);

    List<String> memberIds = [];
    Map<String, dynamic> memberInfo = {};
    Map<String, dynamic> readStatus = {};

    for (String userId in users) {
      User user = await getUserWithId(userId: userId);
      memberIds.add(userId);
      Map<String, dynamic> userMap = {
        'name': user.name,
      };
      memberInfo[userId] = userMap;
      readStatus[userId] = false;
    }

    await _firebaseFirestore.collection(Paths.chats).add(
      {
        'name': name,
        'imageUrl': imageUrl,
        'recentMessage': 'Chat created',
        'recentSender': '',
        'recentTimestamp': Timestamp.now(),
        'memberIds': memberIds,
        'memberInfo': memberInfo,
        'readStatus': readStatus,
      },
    );
    return true;
  }

  @override
  void sendChatMessage(Chat chat, Message message) {
    _firebaseFirestore
        .collection(Paths.chats)
        .doc(chat.id)
        .collection(Paths.messages)
        .add({
      'senderId': message.senderId,
      'text': message.text,
      'imageUrl': message.imageUrl,
      'timestamp': message.timestamp,
    });
  }

  @override
  void setChatRead(
      BuildContext context, Chat chat, bool read, String currentUserId) async {
    _firebaseFirestore.collection(Paths.chats).doc(chat.id).update({
      'readStatus.$currentUserId': read,
    });
  }
}
