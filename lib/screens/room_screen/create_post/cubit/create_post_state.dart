part of 'create_post_cubit.dart';

enum CreatePostStatus { initial, submitting, success, error }

class CreatePostState extends Equatable {
  final File? postImage;
  final String caption;
  final CreatePostStatus status;
  final Failure failure;
  final String link;
  final String roomId;

  const CreatePostState({
    required this.postImage,
    required this.caption,
    required this.status,
    required this.failure,
    required this.link,
    required this.roomId,
  });

  @override
  List<Object?> get props =>
      [postImage, caption, status, roomId, link, failure];

  factory CreatePostState.initial() {
    return const CreatePostState(
      postImage: null,
      link: '',
      roomId: '',
      caption: '',
      status: CreatePostStatus.initial,
      failure: Failure(),
    );
  }

  CreatePostState copyWith({
    File? postImage,
    String? caption,
    CreatePostStatus? status,
    Failure? failure,
    String? link,
    String? roomId,
  }) {
    return CreatePostState(
      postImage: postImage ?? this.postImage,
      caption: caption ?? this.caption,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      link: link ?? this.link,
      roomId: roomId ?? this.roomId,
    );
  }
}
