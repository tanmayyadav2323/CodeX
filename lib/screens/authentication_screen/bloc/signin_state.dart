part of 'signin_bloc.dart';

enum SigninStatus {
  initial,
  loading,
  loaded,
  sendingOTP,
  sentOTP,
  verifyOTP,
  success,
  error
}

class SigninState extends Equatable {
  final String phone;
  final Failure failure;
  final SigninStatus status;

  const SigninState({
    required this.phone,
    required this.failure,
    required this.status,
  });

  factory SigninState.initial() {
    return const SigninState(
      phone: '',
      failure: Failure(),
      status: SigninStatus.initial,
    );
  }

  SigninState copyWith({
    String? phone,
    Failure? failure,
    SigninStatus? status,
  }) {
    return SigninState(
      phone: phone ?? this.phone,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [phone, failure, status];
}
