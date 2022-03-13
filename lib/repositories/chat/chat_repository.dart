import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/config/paths.dart';
import 'package:code/models/message_model.dart';
import 'package:code/models/models.dart';
import 'package:code/models/private_chat_model.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/screens/nav_screen/bloc/editprofile_bloc.dart';
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

  Future<Room> getRoom({required String roomId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.rooms).doc(roomId).get();
    return doc.exists ? Room.fromDoc(doc) : Room.empty;
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

  List<Room> roomsWithUser = [];
  List<Room> roomWithoutUser = [];
  Future<void> searchRoom(String currentUserId, String query) async {
    roomsWithUser = [];
    roomWithoutUser = [];
    final nameSnap = await _firebaseFirestore
        .collection(Paths.rooms)
        .where('name', isGreaterThanOrEqualTo: query)
        .get();
    for (var doc in nameSnap.docs) {
      Room room = Room.fromDoc(doc);
      int flag = 0;
      for (int i = 0; i < room.memberIds.length; i++) {
        if (room.memberIds[i] == currentUserId) {
          roomsWithUser.add(room);
          flag = 1;
          break;
        }
      }
      if (flag == 0) roomWithoutUser.add(room);
    }
  }

  List<Room> searchRoomWithUser() {
    final list = roomsWithUser;
    return list;
  }

  List<Room> searchRoomWithoutUser() {
    final list = roomWithoutUser;
    return list;
  }

  @override
  Future<bool> privateChat(String currentUserId, String userId) async {
    List<String> memberIds = [currentUserId, userId];
    Map<String, dynamic> readStatus = {};

    readStatus[currentUserId] = false;
    readStatus[userId] = false;

    await _firebaseFirestore.collection(Paths.privateChats).add(
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

  @override
  Future<bool> privateChatExists(String currentUserId, String userId) async {
    final snap = await _firebaseFirestore
        .collection(Paths.privateChats)
        .where('memberIds', arrayContains: currentUserId)
        .get();
    return snap.docs.isEmpty;
  }

  @override
  Stream<List<Future<PrivateChat>>> getPrivateChats(String userId) {
    return _firebaseFirestore
        .collection(Paths.privateChats)
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
    String? imageUrl =
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
  void setChatRead(String chatId, bool read, String currentUserId) {
    _firebaseFirestore.collection(Paths.privateChats).doc(chatId).update({
      'readStatus.$currentUserId': read,
    });
  }

  @override
  void likeMessage(String chatId, String messageId, bool isLiked) {
    _firebaseFirestore
        .collection(Paths.privateChats)
        .doc(chatId)
        .collection(Paths.messages)
        .doc(messageId)
        .update({'isLiked': isLiked});
  }

  @override
  void sendChatMessage(String chatId, Message message, String currentUserId) {
    _firebaseFirestore.collection(Paths.privateChats).doc(chatId).update({
      'recentMessage': message.text!.isNotEmpty ? message.text : 'Image Sent',
      'recentTimestamp': DateTime.now(),
      'recentSenderId': currentUserId,
    });
    _firebaseFirestore
        .collection(Paths.privateChats)
        .doc(chatId)
        .collection(Paths.messages)
        .add({
      'senderId': message.senderId,
      'text': message.text,
      'imageUrl': message.imageUrl,
      'timestamp': Timestamp.now(),
      'isLiked': message.isLiked,
    });
  }

  @override
  Stream<List<Future<Message>>> getMessages(String id) {
    return _firebaseFirestore
        .collection(Paths.rooms)
        .doc(id)
        .collection(Paths.messages)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Message.fromDoc(doc)).toList(),
        );
  }

  @override
  void deleteChat(String chatId) {
    _firebaseFirestore.collection(Paths.privateChats).doc(chatId).delete();
  }

  @override
  void deleteMessage(String chatId, String messageId) {
    _firebaseFirestore
        .collection(Paths.privateChats)
        .doc(chatId)
        .collection(Paths.messages)
        .doc(messageId)
        .delete();
  }

  Future<bool> createRoom(Room room, String currentUserId) async {
    final user = await getUserWithId(userId: currentUserId);
    List<String> memberIds = [];
    memberIds.add(currentUserId);
    Map<String, dynamic> readStatus = {};
    Map<String, dynamic> memberInfo = {
      currentUserId: {
        'imageUrl': user.profileImageUrl,
        'name': user.name,
      }
    };

    readStatus[currentUserId] = false;
    await _firebaseFirestore.collection(Paths.rooms).add({
      'roomImage': room.imageUrl,
      'bio': room.bio,
      'name': room.name,
      'numofMembers': 1,
      'memberInfo': memberInfo,
      'creatorId': currentUserId,
      'creatorName': user.name,
      'creationDate': Timestamp.now(),
      'recentMessage': 'Room Created By : ${user.name}',
      'recentTimestamp': Timestamp.now(),
      'memberIds': memberIds,
      'readStatus': readStatus,
    });
    return true;
  }

  Stream<List<Future<Room>>> getRooms(String currentUserId) {
    return _firebaseFirestore
        .collection(Paths.rooms)
        .where('memberIds', arrayContains: currentUserId)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) async {
            return Room.fromDoc(doc);
          }).toList(),
        );
  }

  void sendRoomChatMessage(
      String roomId, Message message, String currentUserId) {
    // _firebaseFirestore.collection(Paths.rooms).doc(roomId).update({
    //   'recentMessage': message.text!.isNotEmpty ? message.text : 'Image Sent',
    //   'recentTimestamp': DateTime.now(),
    //   'recentSenderId': currentUserId,
    // });
    _firebaseFirestore
        .collection(Paths.rooms)
        .doc(roomId)
        .collection(Paths.messages)
        .add({
      'senderId': message.senderId,
      'text': message.text,
      'isLiked': false,
      'imageUrl': message.imageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<List<Future<Message>>> getRoomMessages(String roomId) {
    return _firebaseFirestore
        .collection(Paths.rooms)
        .doc(roomId)
        .collection(Paths.messages)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Message.fromDoc(doc)).toList(),
        );
  }

  Future<void> updateRoom(String roomId, String currentUserId) async {
    final user = await getUserWithId(userId: currentUserId);
    _firebaseFirestore.collection(Paths.rooms).doc(roomId).update({
      'memberIds': FieldValue.arrayUnion([currentUserId]),
      'numofMembers': FieldValue.increment(1),
      'readStatus.$currentUserId': false,
      'memberInfo.$currentUserId': {
        'imageUrl': user.profileImageUrl,
        'name': user.name,
      },
    });
  }

  void toDeleteRoom(String roomId) async {
    _firebaseFirestore.collection(Paths.rooms).doc(roomId).delete();
  }

  Future<void> toRemoveUser(String roomId, String userId) async {
    _firebaseFirestore.collection(Paths.rooms).doc(roomId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
      'numofMembers': FieldValue.increment(-1),
      'readStatus$userId': FieldValue.delete(),
      'memberInfo.$userId': FieldValue.delete(),
    });
  }
}
