part of 'message_bloc.dart';

enum MessageStatus { initial, loading, loaded, error }

class MessageState extends Equatable {
  final List<PrivateChat?> privateChats;
  final Failure failure;
  final MessageStatus status;

  const MessageState({
    required this.privateChats,
    required this.failure,
    required this.status,
  });

  factory MessageState.initial() {
    return const MessageState(
        privateChats: [], failure: Failure(), status: MessageStatus.initial);
  }

  @override
  List<Object> get props => [privateChats, failure, status];

  MessageState copyWith({
    List<PrivateChat?>? privateChats,
    Failure? failure,
    MessageStatus? status,
  }) {
    return MessageState(
      privateChats: privateChats ?? this.privateChats,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
