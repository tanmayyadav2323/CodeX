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
