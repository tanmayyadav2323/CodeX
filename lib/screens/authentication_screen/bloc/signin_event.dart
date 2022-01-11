part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OTPSignInEvent extends SigninEvent {
  final String phone;

  OTPSignInEvent({required this.phone});

  @override
  List<Object> get props => [phone];
}

class OTPVerifyEvent extends SigninEvent {
  final String otp;

  OTPVerifyEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class SignInWithGoogle extends SigninEvent {
  @override
  List<Object> get props => [];
}

class SignInWithGitHub extends SigninEvent {
  final BuildContext context;
  SignInWithGitHub({required this.context});
  @override
  List<Object> get props => [context];
}

class VerificationFailed extends SigninEvent {
  final String message;

  VerificationFailed({required this.message});
  @override
  List<Object> get props => [message];
}
