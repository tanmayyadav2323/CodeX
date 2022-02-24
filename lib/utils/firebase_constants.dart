import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _db = FirebaseFirestore.instance;
final usersRef = _db.collection('users');
final chatsRef = _db.collection('chats');

