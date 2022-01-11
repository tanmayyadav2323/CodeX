import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/models/models.dart';
import 'package:code/utilities/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:code/repositories/auth/base_auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseFirestore? firebaseFirestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  String _verificationId = "";
  @override
  Future<bool> sendOTP({
    required String phone,
    required verificationFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (auth.PhoneAuthCredential credential) {},
        verificationFailed: (err) {
          verificationFailed(err);
        },
        codeSent: (String verificationId, int? resendToken) async {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: otpDuration),
        codeAutoRetrievalTimeout: (_) {},
      );
      return true;
    } on auth.FirebaseAuthException {
      rethrow;
    } on PlatformException {
      rethrow;
    }
  }

  @override
  Future<auth.UserCredential> verifyOTP({required String otp}) async {
    try {
      auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp);
      return await _firebaseAuth.signInWithCredential(credential);
    } on auth.FirebaseAuthException {
      rethrow;
    } on PlatformException {
      rethrow;
    }
  }

  @override
  Future<auth.UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } on auth.FirebaseAuthException {
      rethrow;
    } on PlatformException {
      rethrow;
    }
  }

  @override
  Future<auth.UserCredential> signInWithGitHub(BuildContext context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUrl: redirectUrl,
    );
    final result = await gitHubSignIn.signIn(context);
    final githubAuthCredential =
        auth.GithubAuthProvider.credential(result.token!);
    return await _firebaseAuth.signInWithCredential(githubAuthCredential);
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
