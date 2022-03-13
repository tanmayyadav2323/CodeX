import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code/blocs/auth/auth_bloc.dart';
import 'package:code/helpers/image_helper.dart';
import 'package:code/models/failure_model.dart';
import 'package:code/models/message_model.dart';
import 'package:code/models/private_chat_model.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final AuthBloc _authBloc;
  final ChatRepository _chatRepository;
  final StorageRepository _storageRepository;
  StreamSubscription<List<Future<PrivateChat>>>? _privateChatSubscription;
  StreamSubscription<List<Future<Message>>>? _messageSubscription;

  MessageBloc(
      {required AuthBloc authBloc,
      required ChatRepository chatRepository,
      required StorageRepository storageRepository})
      : _authBloc = authBloc,
        _chatRepository = chatRepository,
        _storageRepository = storageRepository,
        super(MessageState.initial());

  @override
  Future<void> close() {
    _privateChatSubscription?.cancel();
    _messageSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is PrivateChatFetch) {
      yield* _mapPrivateChatFetchToState(event);
    } else if (event is UpdateChats) {
      yield* _mapUpdateChatsToState(event);
    } else if (event is GetMessage) {
      yield* _mapGetMessagesToState(event);
    } else if (event is UpdateMessage) {
      yield* _mapUpdateMessagesToState(event);
    } else if (event is PrivateChatView) {
      yield* _mapChangeView(event);
    } else if (event is EmojiShowing) {
      yield* _mapToEmojiShowing(event);
    } else if (event is UploadChatImage) {
      yield* _mapToUploadChatImage(event);
    } else if (event is ClearSeach) {
      yield* _mapToClearSearch(event);
    }
  }

  Stream<MessageState> _mapPrivateChatFetchToState(
      PrivateChatFetch event) async* {
    yield state.copyWith(status: MessageStatus.initial);
    try {
      final currentUserId = _authBloc.state.user!.uid;
      _privateChatSubscription =
          _chatRepository.getPrivateChats(currentUserId).listen((chats) async {
        final allChats = await Future.wait(chats);
        add(UpdateChats(privateChats: allChats));
      });
      yield state.copyWith(status: MessageStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: MessageStatus.error,
        failure: const Failure(
          message: 'Unable To Fetch Chats',
        ),
      );
    }
  }

  Stream<MessageState> _mapUpdateChatsToState(UpdateChats event) async* {
    yield state.copyWith(privateChats: event.privateChats);
  }

  Stream<MessageState> _mapGetMessagesToState(GetMessage event) async* {
    _messageSubscription =
        _chatRepository.getMessages(event.chatId).listen((message) async {
      final allMessages = await Future.wait(message);
      add(UpdateMessage(allMessages: allMessages));
    });
    if (state.keyboardShowing && state.emojiShowing) {
      yield state.copyWith(emojiShowing: !state.emojiShowing);
    }
  }

  Stream<MessageState> _mapUpdateMessagesToState(UpdateMessage event) async* {
    yield state.copyWith(messages: event.allMessages);
  }

  Stream<MessageState> _mapChangeView(PrivateChatView event) async* {
    yield state.copyWith(isPrivate: event.isPrivate);
  }

  void sendMessage(
      {required String? text,
      required String? imageUrl,
      required String chatId}) {
    final currentUserId = _authBloc.state.user!.uid;
    final message =
        Message(senderId: currentUserId, text: text, imageUrl: imageUrl);
    _chatRepository.sendChatMessage(chatId, message, currentUserId);
  }

  bool currentUserMessage(Message message) {
    final currentUserId = _authBloc.state.user!.uid;
    return (message.senderId == currentUserId);
  }

  void setChatRead(String chatId, bool read) async {
    final currentUserId = _authBloc.state.user!.uid;
    _chatRepository.setChatRead(chatId, read, currentUserId);
  }

  void isLike(String chatId, String messageId, bool isLiked) {
    _chatRepository.likeMessage(chatId, messageId, isLiked);
  }

  bool isRead(PrivateChat chat) {
    final currentUserId = _authBloc.state.user!.uid;
    return chat.readStatus[currentUserId];
  }

  void deleteChat(String chatId) {
    _chatRepository.deleteChat(chatId);
  }

  void deleteMessage(String chatId, String messageId) {
    _chatRepository.deleteMessage(chatId, messageId);
  }

  Stream<MessageState> _mapToEmojiShowing(EmojiShowing event) async* {
    if (event.emojiShowing) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(const Duration(milliseconds: 100));
    }
    yield state.copyWith(
      emojiShowing: event.emojiShowing,
      keyboardShowing: !event.emojiShowing,
    );
  }

  Stream<MessageState> _mapToUploadChatImage(UploadChatImage event) async* {
    yield state.copyWith(status: MessageStatus.uploading);
    final pickedFile = await ImageHelper.pickFromGallery(
        context: event.context,
        cropStyle: CropStyle.rectangle,
        title: "Chat Image");
    if (pickedFile != null) {
      yield state.copyWith(
        chatImage: await _storageRepository.uploadChatImage(
            url: null, imageFile: pickedFile),
      );
    }
    yield state.copyWith(status: MessageStatus.uploaded);
  }

  Stream<MessageState> _mapToClearSearch(ClearSeach event) async* {
    yield state.copyWith(chatImage: null);
  }
}
