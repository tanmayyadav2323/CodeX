import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:code/blocs/blocs.dart';
import 'package:code/models/models.dart';
import 'package:code/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'editprofile_event.dart';
part 'editprofile_state.dart';

class EditprofileBloc extends Bloc<EditprofileEvent, EditprofileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;
  final AuthRepository _authRepository;

  EditprofileBloc({
    required UserRepository userRepository,
    required StorageRepository storageRepository,
    required AuthBloc authBloc,
    required AuthRepository authRepository,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        _storageRepository = storageRepository,
        _authRepository = authRepository,
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
    }
  }

  Stream<EditprofileState> _mapProfileLoadUserToState() async* {
    final userId = _authBloc.state.user!.uid;
    final user = await _userRepository.getUserWithId(userId: userId);
    yield state.copyWith(
        userId: userId,
        name: user.name,
        username: user.username,
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
    yield state.copyWith(
        username: event.username, status: EditprofileStatus.initial);
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
      await usernameExists();
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

  Stream<EditprofileState> usernameExists() async* {
    final checkUsername =
        await _userRepository.usernameExists(query: state.username);
    if (checkUsername) {
      yield state.copyWith(
        status: EditprofileStatus.error,
        failure: const Failure(message: 'Username Already Exists'),
      );
    }
  }
}
