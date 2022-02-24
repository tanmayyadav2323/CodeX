part of 'editprofile_bloc.dart';

enum EditprofileStatus { initial, userNameExists, submitting, success, error }

class EditprofileState extends Equatable {
  final String userId;
  final File? image;
  final String? profileImageurl;
  final String name;
  final String username;
  final String initialUsername;
  final String skills;
  final String linkedIn;
  final String github;
  final EditprofileStatus status;
  final Failure failure;

  const EditprofileState({
    required this.userId,
    required this.image,
    this.profileImageurl,
    required this.name,
    required this.username,
    required this.initialUsername,
    required this.skills,
    required this.linkedIn,
    required this.github,
    required this.status,
    required this.failure,
  });

  factory EditprofileState.initial() {
    return const EditprofileState(
      userId: '',
      image: null,
      profileImageurl: null,
      initialUsername: '',
      name: '',
      username: '',
      skills: '',
      linkedIn: '',
      github: '',
      failure: Failure(),
      status: EditprofileStatus.initial,
    );
  }

  @override
  List<Object?> get props {
    return [
      userId,
      profileImageurl,
      image,
      name,
      username,
      initialUsername,
      skills,
      linkedIn,
      github,
      status,
      failure,
    ];
  }

  EditprofileState copyWith({
    String? userId,
    File? image,
    String? profileImageurl,
    String? name,
    String? username,
    String? initialUsername,
    String? skills,
    String? linkedIn,
    String? github,
    EditprofileStatus? status,
    Failure? failure,
  }) {
    return EditprofileState(
      userId: userId ?? this.userId,
      image: image ?? this.image,
      profileImageurl: profileImageurl ?? this.profileImageurl,
      name: name ?? this.name,
      username: username ?? this.username,
      initialUsername: initialUsername ?? this.initialUsername,
      skills: skills ?? this.skills,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
