import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:code/blocs/blocs.dart';
import 'package:code/models/models.dart';
import 'package:code/models/post_model.dart';
import 'package:code/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;

  CreatePostCubit({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void linkChanged(String link) {
    emit(state.copyWith(link: link, status: CreatePostStatus.initial));
  }

  void submit(String roomId) async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user!.uid);
      final postImageUrl = state.postImage != null
          ? await _storageRepository.uploadPostImage(image: state.postImage!)
          : '';
      final post = Post(
        author: author,
        imageUrl: postImageUrl,
        caption: state.caption,
        link: state.link,
        likes: 0,
        date: DateTime.now(),
        roomId: roomId,
      );
      await _postRepository.createPost(post: post);
      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          failure: Failure(message: err.toString()),
        ),
      );
    }
  }
}
