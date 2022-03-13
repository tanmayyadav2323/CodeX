part of 'message_bloc.dart';

enum MessageStatus {
  initial,
  uploading,
  uploaded,
  loading,
  loaded,
  error,
}

class MessageState extends Equatable {
  final List<PrivateChat?> privateChats;
  final List<Message> messages;
  final Failure failure;
  final bool isPrivate;
  final bool emojiShowing;
  final bool keyboardShowing;
  final String? chatImage;
  final MessageStatus status;

  const MessageState({
    required this.privateChats,
    required this.messages,
    required this.failure,
    required this.isPrivate,
    required this.emojiShowing,
    required this.keyboardShowing,
    required this.chatImage,
    required this.status,
  });

  factory MessageState.initial() {
    return const MessageState(
      privateChats: [],
      messages: [],
      isPrivate: true,
      failure: Failure(),
      chatImage: null,
      emojiShowing: false,
      keyboardShowing: false,
      status: MessageStatus.initial,
    );
  }

  @override
  List<Object?> get props => [
        privateChats,
        failure,
        status,
        messages,
        isPrivate,
        emojiShowing,
        chatImage,
        keyboardShowing
      ];

  MessageState copyWith({
    List<PrivateChat?>? privateChats,
    List<Message>? messages,
    Failure? failure,
    bool? isPrivate,
    bool? emojiShowing,
    bool? keyboardShowing,
    String? chatImage,
    MessageStatus? status,
  }) {
    return MessageState(
      privateChats: privateChats ?? this.privateChats,
      messages: messages ?? this.messages,
      failure: failure ?? this.failure,
      isPrivate: isPrivate ?? this.isPrivate,
      emojiShowing: emojiShowing ?? this.emojiShowing,
      keyboardShowing: keyboardShowing ?? this.keyboardShowing,
      chatImage: chatImage ?? this.chatImage,
      status: status ?? this.status,
    );
  }
}
