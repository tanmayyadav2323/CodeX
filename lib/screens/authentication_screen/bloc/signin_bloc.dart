import 'package:bloc/bloc.dart';
import 'package:code/models/models.dart';
import 'package:code/repositories/auth/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthRepository _authRepository;

  SigninBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(SigninState.initial());

  @override
  Stream<SigninState> mapEventToState(SigninEvent event) async* {
    if (event is OTPSignInEvent) {
      yield* _mapEventToSendOTP(event);
    } else if (event is OTPVerifyEvent) {
      yield* _mapEventToVerifyOTP(event);
    } else if (event is SignInWithGoogle) {
      yield* _mapEventToSignInWithGoogle(event);
    } else if (event is SignInWithGitHub) {
      yield* _mapEventToSignInWithGitHub(event);
    } else if (event is VerificationFailed) {
      yield* _mapEventToVerificationFailed(event);
    }
  }

  Stream<SigninState> _mapEventToSendOTP(OTPSignInEvent event) async* {
    try {
      yield state.copyWith(phone: event.phone, status: SigninStatus.sendingOTP);
      await _authRepository.sendOTP(
        phone: event.phone,
        verificationFailed: _verificationFailed,
      );
      yield state.copyWith(status: SigninStatus.sentOTP);
    } catch (exception) {
      add(VerificationFailed(message: 'Unable to send OTP to this number'));
    }
  }

  Stream<SigninState> _mapEventToVerifyOTP(OTPVerifyEvent event) async* {
    try {
      yield state.copyWith(status: SigninStatus.verifyOTP);
      await _authRepository.verifyOTP(otp: event.otp);
      yield state.copyWith(status: SigninStatus.success);
    } catch (exception) {
      add(VerificationFailed(message: 'Unable to verify the OTP'));
    }
  }

  Stream<SigninState> _mapEventToSignInWithGoogle(
      SignInWithGoogle event) async* {
    try {
      yield state.copyWith(status: SigninStatus.loading);
      await _authRepository.signInWithGoogle();
      yield state.copyWith(status: SigninStatus.loaded);
    } catch (exception) {
      add(VerificationFailed(message: 'Unable to verify your Google account'));
    }
  }

  Stream<SigninState> _mapEventToSignInWithGitHub(
      SignInWithGitHub event) async* {
    try {
      yield state.copyWith(status: SigninStatus.loading);
      await _authRepository.signInWithGitHub(event.context);
      yield state.copyWith(status: SigninStatus.loaded);
    } catch (exception) {
      add(VerificationFailed(message: 'Unable to verify your GitHub account'));
    }
  }

  Stream<SigninState> _mapEventToVerificationFailed(
      VerificationFailed event) async* {
    yield state.copyWith(
      status: SigninStatus.error,
      failure: Failure(message: event.message),
    );
  }

  void _verificationFailed(FirebaseAuthException err) {
    add(VerificationFailed(
        message: 'Unable to send OTP. Please Try again Later'));
  }
}
