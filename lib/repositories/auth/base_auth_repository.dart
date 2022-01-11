import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;

  Future<bool> sendOTP({
    required String phone,
    required verificationFailed,
  });
  Future<auth.UserCredential> verifyOTP({required String otp});
  Future<auth.UserCredential> signInWithGoogle();
  Future<auth.UserCredential> signInWithGitHub(BuildContext context);
  Future<void> logOut();
}
