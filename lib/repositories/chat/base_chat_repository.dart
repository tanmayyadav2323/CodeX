import 'dart:io';

import 'package:code/models/chat_model.dart';
import 'package:code/models/message_model.dart';
import 'package:code/models/user_model.dart';
import 'package:flutter/material.dart';

abstract class BaseChatRepository {
  Future<User> getUserWithId({required String userId});
  Future<List<User>> searchUser(String currentUserId, String query);
  Future<bool> createChat(
      BuildContext context, String name, File file, List<String> users);
  void sendChatMessage(Chat chat, Message message);
  void setChatRead(
      BuildContext context, Chat chat, bool read, String currentUserId);
}
