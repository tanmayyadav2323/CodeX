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

class UploadRoomImage extends EditprofileEvent {
  final BuildContext context;
  const UploadRoomImage({
    required this.context,
  });
  @override
  List<Object> get props => [context];
}

class CreateRoom extends EditprofileEvent {
  final Room room;
  const CreateRoom({
    required this.room,
  });
  @override
  List<Object> get props => [room];
}

class ClearRoomImage extends EditprofileEvent {
  const ClearRoomImage();
  @override
  List<Object> get props => [];
}

class FetchRoom extends EditprofileEvent {
  const FetchRoom();
  @override
  List<Object> get props => [];
}

class UpdateAllRooms extends EditprofileEvent {
  List<Room> rooms;
  UpdateAllRooms({
    required this.rooms,
  });
  @override
  List<Object> get props => [rooms];
}

class SearchRoom extends EditprofileEvent {
  final String roomName;
  const SearchRoom({
    required this.roomName,
  });

  @override
  List<Object> get props => [roomName];
}

class ClearRoomSearch extends EditprofileEvent {
  const ClearRoomSearch();
  @override
  List<Object> get props => [];
}

class UpdateSingleRoom extends EditprofileEvent {
  const UpdateSingleRoom();
  @override
  List<Object> get props => [];
}
