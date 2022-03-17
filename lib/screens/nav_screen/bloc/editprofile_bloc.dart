import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:code/blocs/blocs.dart';
import 'package:code/helpers/image_helper.dart';
import 'package:code/models/models.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';

part 'editprofile_event.dart';
part 'editprofile_state.dart';

class EditprofileBloc extends Bloc<EditprofileEvent, EditprofileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;
  final AuthRepository _authRepository;
  final ChatRepository _chatRepository;
  StreamSubscription<List<Future<Room>>>? _roomSubscription;

  EditprofileBloc(
      {required UserRepository userRepository,
      required StorageRepository storageRepository,
      required AuthBloc authBloc,
      required AuthRepository authRepository,
      required ChatRepository chatRepository})
      : _userRepository = userRepository,
        _authBloc = authBloc,
        _storageRepository = storageRepository,
        _authRepository = authRepository,
        _chatRepository = chatRepository,
        super(EditprofileState.initial());

  @override
  Stream<EditprofileState> mapEventToState(EditprofileEvent event) async* {
    if (event is ProfileLoadUserEvent) {
      yield* _mapProfileLoadUserToState();
    } else if (event is ProfileNameChanged) {
      yield* _mapProfileNameToState(event);
    } else if (event is ProfileUsernameChanged) {
      yield* _mapProfileUsernameToState(event);
    } else if (event is ProfileSkillsChanged) {
      yield* _mapProfileSkillsToState(event);
    } else if (event is ProfileLinkedInChanged) {
      yield* _mapProfileLinkedInToState(event);
    } else if (event is ProfileGithubChanged) {
      yield* _mapProfileGithubToState(event);
    } else if (event is ProfileImageChanged) {
      yield* _mapProfileImageToState(event);
    } else if (event is ProfileUpdateEvent) {
      yield* _mapProfileUpdateToState(event);
    } else if (event is ProfileLogOutEvent) {
      yield* _mapProfileLogOutToState(event);
    } else if (event is UploadRoomImage) {
      yield* _mapToUploadRoomImage(event);
    } else if (event is CreateRoom) {
      yield* _mapToCreateRoom(event);
    } else if (event is ClearRoomImage) {
      yield* _mapToClearRoomImage(event);
    } else if (event is FetchRoom) {
      yield* _mapToFetchRoom(event);
    } else if (event is UpdateAllRooms) {
      yield* _mapToUpdateAllRooms(event);
    } else if (event is SearchRoom) {
      yield* _mapToSearchRoom(event);
    } else if (event is ClearRoomSearch) {
      yield* _mapToClearSearch(event);
    }
  }

  Stream<EditprofileState> _mapProfileLoadUserToState() async* {
    final userId = _authBloc.state.user!.uid;
    final user = await _userRepository.getUserWithId(userId: userId);
    yield state.copyWith(
        userId: userId,
        name: user.name,
        username: user.username,
        initialUsername: user.username,
        skills: user.skills,
        profileImageurl: user.profileImageUrl,
        linkedIn: user.linkedIn,
        github: user.github,
        status: EditprofileStatus.initial);
  }

  Stream<EditprofileState> _mapProfileNameToState(
      ProfileNameChanged event) async* {
    yield state.copyWith(name: event.name, status: EditprofileStatus.initial);
  }

  Stream<EditprofileState> _mapProfileUsernameToState(
      ProfileUsernameChanged event) async* {
    if (event.username.length >= 5 && event.username != state.initialUsername) {
      final check = await _userRepository.usernameExists(query: event.username);
      if (check) {
        yield state.copyWith(
            userNameStatus: UserNameStatus.exists, username: event.username);
      } else {
        yield state.copyWith(
            username: event.username, userNameStatus: UserNameStatus.notExists);
      }
    } else {
      yield state.copyWith(
          username: event.username, userNameStatus: UserNameStatus.notExists);
    }
  }

  Stream<EditprofileState> _mapProfileSkillsToState(
      ProfileSkillsChanged event) async* {
    yield state.copyWith(
        skills: event.skills, status: EditprofileStatus.initial);
  }

  Stream<EditprofileState> _mapProfileLinkedInToState(
      ProfileLinkedInChanged event) async* {
    yield state.copyWith(
        linkedIn: event.linkedIn, status: EditprofileStatus.initial);
  }

  Stream<EditprofileState> _mapProfileGithubToState(
      ProfileGithubChanged event) async* {
    yield state.copyWith(
        github: event.github, status: EditprofileStatus.initial);
  }

  Stream<EditprofileState> _mapProfileImageToState(
      ProfileImageChanged event) async* {
    yield state.copyWith(image: event.image, status: EditprofileStatus.initial);
  }

  Stream<EditprofileState> _mapProfileLogOutToState(
      ProfileLogOutEvent event) async* {
    _authRepository.logOut();
  }

  Stream<EditprofileState> _mapProfileUpdateToState(
      ProfileUpdateEvent event) async* {
    yield state.copyWith(status: EditprofileStatus.submitting);
    try {
      final user = await _userRepository.getUserWithId(userId: state.userId);
      var profileImageUrl = user.profileImageUrl;
      if (state.image != null) {
        profileImageUrl = await _storageRepository.uploadProfileImage(
            image: state.image!, url: profileImageUrl);
      }
      final updateUser = user.copyWith(
        username: state.username,
        name: state.name,
        github: state.github,
        linkedIn: state.linkedIn,
        profileImageUrl: profileImageUrl,
        skills: state.skills,
      );
      await _userRepository.updateUser(user: updateUser);
      yield state.copyWith(status: EditprofileStatus.success);
    } catch (err) {
      yield state.copyWith(
        status: EditprofileStatus.error,
        failure:
            const Failure(message: 'We were unable to update your profile'),
      );
    }
  }

  Stream<EditprofileState> _mapToUploadRoomImage(UploadRoomImage event) async* {
    yield state.copyWith(status: EditprofileStatus.uploadingRoomImage);
    final pickedFile = await ImageHelper.pickFromGallery(
      context: event.context,
      cropStyle: CropStyle.rectangle,
      title: "Room Image",
    );
    if (pickedFile != null) {
      final rImage = await _storageRepository.uploadProfileImage(
          url: null, image: pickedFile);
      yield state.copyWith(
          roomImage: rImage, status: EditprofileStatus.uploadedRoomImage);
    }
  }

  Stream<EditprofileState> _mapToCreateRoom(CreateRoom event) async* {
    final userId = _authBloc.state.user!.uid;
    _chatRepository.createRoom(event.room, userId);
  }

  Stream<EditprofileState> _mapToClearRoomImage(ClearRoomImage event) async* {
    yield state.copyWith(roomImage: null);
  }

  Stream<EditprofileState> _mapToFetchRoom(FetchRoom event) async* {
    try {
      final currentUserId = _authBloc.state.user!.uid;
      _roomSubscription =
          _chatRepository.getRooms(currentUserId).listen((room) async {
        final rooms = await Future.wait(room);
        add(UpdateAllRooms(rooms: rooms));
      });
    } catch (err) {
      yield state.copyWith(
        status: EditprofileStatus.error,
        failure: const Failure(
          message: 'Unable To Fetch Rooms',
        ),
      );
    }
  }

  Stream<EditprofileState> _mapToUpdateAllRooms(UpdateAllRooms event) async* {
    yield state.copyWith(rooms: event.rooms);
  }

  Stream<EditprofileState> _mapToSearchRoom(SearchRoom event) async* {
    yield state.copyWith(
        status: EditprofileStatus.searchingRoom, withMe: [], withoutMe: []);
    final currentUserId = _authBloc.state.user!.uid;
    await _chatRepository.searchRoom(currentUserId, event.roomName);
    final withMe = _chatRepository.searchRoomWithUser();
    final withoutMe = _chatRepository.searchRoomWithoutUser();
    yield state.copyWith(withMe: withMe, withoutMe: withoutMe);
  }

  Stream<EditprofileState> _mapToClearSearch(ClearRoomSearch event) async* {
    yield state
        .copyWith(status: EditprofileStatus.initial, withMe: [], withoutMe: []);
  }

  void updateRoom(String roomId) {
    final currentUserId = _authBloc.state.user!.uid;
    _chatRepository.updateRoom(roomId, currentUserId);
  }
}
