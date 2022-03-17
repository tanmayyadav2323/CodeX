part of 'editprofile_bloc.dart';

enum EditprofileStatus {
  initial,
  userNameExists,
  userNameNotValid,
  submitting,
  success,
  uploadingRoomImage,
  uploadedRoomImage,
  searchingRoom,
  searchedRoom,
  error
}

enum UserNameStatus { initial, exists, notExists }

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
  final String? roomImage;
  final List<Room> rooms;
  final List<Room> withMe;
  final List<Room> withoutMe;
  final UserNameStatus userNameStatus;

  const EditprofileState({
    required this.userId,
    required this.image,
    required this.profileImageurl,
    required this.name,
    required this.username,
    required this.initialUsername,
    required this.skills,
    required this.linkedIn,
    required this.github,
    required this.status,
    required this.failure,
    required this.roomImage,
    required this.rooms,
    required this.withMe,
    required this.withoutMe,
    required this.userNameStatus,
  });

  factory EditprofileState.initial() {
    return const EditprofileState(
      userId: '',
      image: null,
      profileImageurl: null,
      userNameStatus: UserNameStatus.initial,
      initialUsername: '',
      withMe: [],
      withoutMe: [],
      name: '',
      username: '',
      skills: '',
      linkedIn: '',
      rooms: [],
      roomImage: null,
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
      rooms,
      username,
      withMe,
      withoutMe,
      initialUsername,
      roomImage,
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
    String? roomImage,
    List<Room>? rooms,
    List<Room>? withMe,
    List<Room>? withoutMe,
    UserNameStatus? userNameStatus,
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
      roomImage: roomImage ?? this.roomImage,
      rooms: rooms ?? this.rooms,
      withMe: withMe ?? this.withMe,
      withoutMe: withoutMe ?? this.withoutMe,
      userNameStatus: userNameStatus ?? this.userNameStatus,
    );
  }
}
