import 'dart:io';

import 'package:code/models/models.dart';
import 'package:code/repositories/storage/base_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String> _uploadImage(
      {required File image, required String ref}) async {
    try {
      final downloadUrl = await _firebaseStorage
          .ref(ref)
          .putFile(image)
          .then((tasksnapshot) => tasksnapshot.ref.getDownloadURL());
      return downloadUrl;
    } on FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message!);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message!);
    }
  }

  @override
  Future<String> uploadProfileImage({String? url, required File image}) async {
    try {
      String? imageId = const Uuid().v4();

      if (url!.isNotEmpty) {
        final exp = RegExp(r'userProfile_(.*).jpg');
        imageId = exp.firstMatch(url)![1];
      }

      final downloadUrl = await _uploadImage(
          image: image, ref: 'images/users/userProfile_$imageId.jpg');
      return downloadUrl;
    } on FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message!);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message!);
    }
  }
}
