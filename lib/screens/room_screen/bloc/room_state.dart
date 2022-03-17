part of 'room_bloc.dart';

enum RoomStatus { initial, uploadingImage, uploadedImage, error }

class RoomState extends Equatable {
  final List<Message> messages;
  final List<Post> posts;
  final String image;
  final bool emojiShowing;
  final Room room;
  final RoomStatus status;
  final int selectedIndex;
  final Failure failure;

  const RoomState({
    required this.messages,
    required this.posts,
    required this.image,
    required this.emojiShowing,
    required this.room,
    required this.status,
    required this.selectedIndex,
    required this.failure,
  });

  @override
  List<Object?> get props => [
        image,
        failure,
        messages,
        emojiShowing,
        room,
        status,
        selectedIndex,
        posts
      ];

  factory RoomState.initial() {
    return const RoomState(
      room: Room.empty,
      image: '',
      posts: [],
      selectedIndex: 0,
      messages: [],
      status: RoomStatus.initial,
      failure: Failure(),
      emojiShowing: false,
    );
  }

  RoomState copyWith({
    List<Message>? messages,
    List<Post>? posts,
    String? image,
    bool? emojiShowing,
    Room? room,
    RoomStatus? status,
    int? selectedIndex,
    Failure? failure,
  }) {
    return RoomState(
      messages: messages ?? this.messages,
      posts: posts ?? this.posts,
      image: image ?? this.image,
      emojiShowing: emojiShowing ?? this.emojiShowing,
      room: room ?? this.room,
      status: status ?? this.status,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      failure: failure ?? this.failure,
    );
  }
}
