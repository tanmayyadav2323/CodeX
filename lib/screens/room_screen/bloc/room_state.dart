part of 'room_bloc.dart';

class RoomState extends Equatable {
  final List<Message> messages;
  final String? image;
  final bool emojiShowing;
  final Room room;
  final Failure failure;

  const RoomState({
    required this.messages,
    required this.image,
    required this.emojiShowing,
    required this.room,
    required this.failure,
  });

  @override
  List<Object?> get props => [image, failure, messages, emojiShowing, room];

  factory RoomState.initial() {
    return const RoomState(
      room: Room.empty,
      image: null,
      messages: [],
      failure: Failure(),
      emojiShowing: false,
    );
  }

  RoomState copyWith({
    List<Message>? messages,
    String? image,
    bool? emojiShowing,
    Room? room,
    Failure? failure,
  }) {
    return RoomState(
      messages: messages ?? this.messages,
      image: image ?? this.image,
      emojiShowing: emojiShowing ?? this.emojiShowing,
      room: room ?? this.room,
      failure: failure ?? this.failure,
    );
  }
}
