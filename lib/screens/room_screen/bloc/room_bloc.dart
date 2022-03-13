import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code/blocs/blocs.dart';
import 'package:code/models/models.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final AuthBloc _authBloc;
  final ChatRepository _chatRepository;
  final StorageRepository _storageRepository;
  StreamSubscription<List<Future<Room>>>? _roomChatSubscription;
  StreamSubscription<List<Future<Message>>>? _messageSubscription;

  @override
  Future<void> close() {
    _roomChatSubscription?.cancel();
    _messageSubscription?.cancel();
    return super.close();
  }

  RoomBloc(
      {required AuthBloc authBloc,
      required ChatRepository chatRepository,
      required StorageRepository storageRepository})
      : _authBloc = authBloc,
        _chatRepository = chatRepository,
        _storageRepository = storageRepository,
        super(RoomState.initial());

  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async* {
    if (event is GetMessages) {
      yield* _mapGetMessagesToState(event);
    } else if (event is UpdateMessages) {
      yield* _mapUpdateMessagesToState(event);
    } else if (event is EmojiShowing) {
      yield* _mapToEmojiShowing(event);
    } else if (event is GetRoom) {
      yield* _mapToGetRoom(event);
    } else if (event is RemoveUser) {
      yield* _mapToRemoveUser(event);
    }
  }

  Stream<RoomState> _mapGetMessagesToState(GetMessages event) async* {
    _messageSubscription =
        _chatRepository.getMessages(event.roomId).listen((message) async {
      final allMessages = await Future.wait(message);
      add(UpdateMessages(messages: allMessages));
    });
  }

  Stream<RoomState> _mapUpdateMessagesToState(UpdateMessages event) async* {
    yield state.copyWith(messages: event.messages);
  }

  void sendMessage(
      {required String? text,
      required String? imageUrl,
      required String roomId}) {
    final currentUserId = _authBloc.state.user!.uid;
    final message =
        Message(senderId: currentUserId, text: text, imageUrl: imageUrl);
    _chatRepository.sendRoomChatMessage(roomId, message, currentUserId);
  }

  bool currentUserMessage(String id) {
    final currentUserId = _authBloc.state.user!.uid;
    return (id == currentUserId);
  }

  Stream<RoomState> _mapToEmojiShowing(EmojiShowing event) async* {
    if (event.emojiShowing) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(const Duration(milliseconds: 50));
    }
    yield state.copyWith(
      emojiShowing: event.emojiShowing,
    );
  }

  Stream<RoomState> _mapToGetRoom(GetRoom event) async* {
    Room room = await _chatRepository.getRoom(roomId: event.roomId);
    yield state.copyWith(room: room);
  }

  void createChat(String userId) {
    final currentUserId = _authBloc.state.user!.uid;
    _chatRepository.privateChat(currentUserId, userId);
  }

  Stream<RoomState> _mapToRemoveUser(RemoveUser event) async* {
    await _chatRepository.toRemoveUser(state.room.id!, event.userId);
    add(GetRoom(roomId: state.room.id!));
  }

  String currentUserId() {
    return _authBloc.state.user!.uid;
  }

  void deleteRoom(String roomId) {
    _chatRepository.toDeleteRoom(roomId);
  }
}
