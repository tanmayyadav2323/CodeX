part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class PrivateChatFetch extends MessageEvent {
  PrivateChatFetch();

  @override
  List<Object> get props => [];
}

class UpdateChats extends MessageEvent {
  List<PrivateChat?> privateChats;
  UpdateChats({
    required this.privateChats,
  });
  @override
  List<Object> get props => [privateChats];
}

class SendMessage extends MessageEvent {
  final String text;

  const SendMessage({required this.text});

  @override
  List<Object> get props => [text];
}

class GetMessage extends MessageEvent {
  final String chatId;

  const GetMessage({
    required this.chatId,
  });

  @override
  List<Object> get props => [chatId];
}

class UpdateMessage extends MessageEvent {
  final List<Message> allMessages;

  const UpdateMessage({
    required this.allMessages,
  });
  @override
  List<Object> get props => [allMessages];
}

class PrivateChatView extends MessageEvent {
  final bool isPrivate;

  const PrivateChatView({
    required this.isPrivate,
  });

  @override
  List<Object> get props => [isPrivate];
}

class EmojiShowing extends MessageEvent {
  final bool emojiShowing;

  const EmojiShowing({
    required this.emojiShowing,
  });

  @override
  List<Object> get props => [emojiShowing];
}

class KeyboardShowing extends MessageEvent {
  final bool keyBoardVisible;

  const KeyboardShowing({
    required this.keyBoardVisible,
  });

  @override
  List<Object> get props => [keyBoardVisible];
}

class UploadChatImage extends MessageEvent {
  final BuildContext context;

  const UploadChatImage({required this.context});

  @override
  List<Object> get props => [context];
}

class ClearSeach extends MessageEvent {
  ClearSeach();

  @override
  List<Object> get props => [];
}
