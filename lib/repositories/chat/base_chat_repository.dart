import 'dart:io';

import 'package:code/models/models.dart';
import 'package:flutter/material.dart';

abstract class BaseChatRepository {
  Future<User> getUserWithId({required String userId});
  // Future<Room> getRoom({required String roomId});
  Future<List<User>> searchUser(String currentUserId, String query);
  Future<bool> privateChat(String currentUserId, String userId);
  Future<bool> privateChatExists(String currentUserId, String userId);
  Stream<List<Future<PrivateChat>>> getPrivateChats(String userId);
  Future<bool> createChat(
      BuildContext context, String name, File file, List<String> users);
  void setChatRead(String chatId, bool read, String currentUserId);
  void likeMessage(String chatId, String messageId, bool isLiked);
  void sendChatMessage(String chatId, Message message, String currentUserId);
  Stream<List<Future<Message>>> getMessages(String id);
  void deleteChat(String chatId);
  void deleteMessage(String chatId, String messageId);
}
