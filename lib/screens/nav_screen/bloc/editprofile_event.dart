part of 'editprofile_bloc.dart';

abstract class EditprofileEvent extends Equatable {
  const EditprofileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadUserEvent extends EditprofileEvent {
  const ProfileLoadUserEvent();

  @override
  List<Object> get props => [];
}

class ProfileNameChanged extends EditprofileEvent {
  final String name;
  const ProfileNameChanged({required this.name});
  @override
  List<Object> get props => [name];
}

class ProfileUsernameChanged extends EditprofileEvent {
  final String username;
  const ProfileUsernameChanged({required this.username});
  @override
  List<Object> get props => [username];
}

class ProfileImageChanged extends EditprofileEvent {
  final File? image;
  const ProfileImageChanged({required this.image});
  @override
  List<Object> get props => [image!];
}

class ProfileSkillsChanged extends EditprofileEvent {
  final String skills;
  const ProfileSkillsChanged({required this.skills});
  @override
  List<Object> get props => [skills];
}

class ProfileLinkedInChanged extends EditprofileEvent {
  final String linkedIn;
  const ProfileLinkedInChanged({required this.linkedIn});
  @override
  List<Object> get props => [linkedIn];
}

class ProfileGithubChanged extends EditprofileEvent {
  final String github;
  const ProfileGithubChanged({required this.github});
  @override
  List<Object> get props => [github];
}

class ProfileUpdateEvent extends EditprofileEvent {
  const ProfileUpdateEvent();
  @override
  List<Object> get props => [];
}

class ProfileLogOutEvent extends EditprofileEvent {
  const ProfileLogOutEvent();
  @override
  List<Object> get props => [];
}
