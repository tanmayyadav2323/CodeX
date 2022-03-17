part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class GetMessages extends RoomEvent {
  final String roomId;
  const GetMessages({required this.roomId});
  @override
  List<Object> get props => [roomId];
}

class UpdateMessages extends RoomEvent {
  final List<Message> messages;
  const UpdateMessages({
    required this.messages,
  });
  @override
  List<Object> get props => [messages];
}

class EmojiShowing extends RoomEvent {
  final bool emojiShowing;

  const EmojiShowing({
    required this.emojiShowing,
  });

  @override
  List<Object> get props => [emojiShowing];
}

class GetRoom extends RoomEvent {
  final String roomId;

  const GetRoom({
    required this.roomId,
  });

  @override
  List<Object> get props => [roomId];
}

class RemoveUser extends RoomEvent {
  final String userId;
  RemoveUser({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}

class UploadImage extends RoomEvent {
  final BuildContext context;
  UploadImage({
    required this.context,
  });

  @override
  List<Object> get props => [context];
}

class ClrSearch extends RoomEvent {
  const ClrSearch();
  @override
  List<Object> get props => [];
}

class ChangeView extends RoomEvent {
  final int index;
  const ChangeView({
    required this.index,
  });
  @override
  List<Object> get props => [index];
}

class GetPosts extends RoomEvent {
  final String roomId;
  GetPosts({
    required this.roomId,
  });

  @override
  List<Object> get props => [roomId];
}

class UpdatePosts extends RoomEvent {
  final List<Post> posts;
  UpdatePosts({
    required this.posts,
  });

  @override
  List<Object> get props => [posts];
}
