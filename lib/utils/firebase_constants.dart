import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

FirebaseFirestore _db = FirebaseFirestore.instance;
final usersRef = _db.collection('users');
final privatechatsRef = _db.collection('privateChats');
final DateFormat timeFormat = DateFormat('E, h:mm a');
