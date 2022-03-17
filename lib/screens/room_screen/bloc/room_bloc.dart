import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code/blocs/blocs.dart';
import 'package:code/config/paths.dart';
import 'package:code/helpers/image_helper.dart';
import 'package:code/models/models.dart';
import 'package:code/models/post_model.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/screens/room_screen/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final AuthBloc _authBloc;
  final ChatRepository _chatRepository;
  final PostRepository _postRepository;
  final LikedPostsCubit _likedPostsCubit;
  final StorageRepository _storageRepository;
  StreamSubscription<List<Future<Post>>>? _postSubscription;
  StreamSubscription<List<Future<Message>>>? _messageSubscription;

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    _messageSubscription?.cancel();
    return super.close();
  }

  RoomBloc({
    required AuthBloc authBloc,
    required ChatRepository chatRepository,
    required LikedPostsCubit likedPostsCubit,
    required StorageRepository storageRepository,
    required PostRepository postRepository,
  })  : _authBloc = authBloc,
        _chatRepository = chatRepository,
        _likedPostsCubit = likedPostsCubit,
        _storageRepository = storageRepository,
        _postRepository = postRepository,
        super(RoomState.initial());

  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async* {
    if (event is GetMessages) {
      yield* _mapGetMessagesToState(event);
    } else if (event is UpdateMessages) {
      yield* _mapUpdateMessagesToState(event);
    } else if (event is EmojiShowing) {
      yield* _mapToEmojiShowing(event);
    } else if (event is GetRoom) {
      yield* _mapToGetRoom(event);
    } else if (event is RemoveUser) {
      yield* _mapToRemoveUser(event);
    } else if (event is UploadImage) {
      yield* _mapToUploadChatImage(event);
    } else if (event is ClrSearch) {
      yield* _mapToClearSearch(event);
    } else if (event is ChangeView) {
      yield* _mapToChangeView(event);
    } else if (event is GetPosts) {
      yield* _mapToGetRoomPosts(event);
    } else if (event is UpdatePosts) {
      yield* _mapUpdatePostsToState(event);
    }
  }

  Stream<RoomState> _mapGetMessagesToState(GetMessages event) async* {
    _messageSubscription = _chatRepository
        .getMessages(event.roomId, Paths.rooms)
        .listen((message) async {
      final allMessages = await Future.wait(message);
      add(UpdateMessages(messages: allMessages));
    });
  }

  Stream<RoomState> _mapToGetRoomPosts(GetPosts event) async* {
    _postSubscription =
        _postRepository.getUserPosts(roomId: event.roomId).listen((post) async {
      final allPosts = await Future.wait(post);
      add(UpdatePosts(posts: allPosts));
    });
  }

  Stream<RoomState> _mapUpdatePostsToState(UpdatePosts event) async* {
    yield state.copyWith(posts: event.posts);
  }

  void deletePost(String id) {
    _postRepository.deletePost(id);
  }

  Stream<RoomState> _mapUpdateMessagesToState(UpdateMessages event) async* {
    yield state.copyWith(messages: event.messages);
  }

  void sendMessage(
      {required String? text,
      required String? imageUrl,
      required String roomId}) {
    final currentUserId = _authBloc.state.user!.uid;
    final message =
        Message(senderId: currentUserId, text: text, imageUrl: imageUrl);
    _chatRepository.sendRoomChatMessage(roomId, message, currentUserId);
    add(const ClrSearch());
  }

  bool currentUserMessage(String id) {
    final currentUserId = _authBloc.state.user!.uid;
    return (id == currentUserId);
  }

  Stream<RoomState> _mapToEmojiShowing(EmojiShowing event) async* {
    if (event.emojiShowing) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(const Duration(milliseconds: 100));
    }
    yield state.copyWith(
      emojiShowing: event.emojiShowing,
    );
  }

  Stream<RoomState> _mapToGetRoom(GetRoom event) async* {
    Room room = await _chatRepository.getRoom(roomId: event.roomId);
    yield state.copyWith(room: room);
  }

  void createChat(String userId) {
    final currentUserId = _authBloc.state.user!.uid;
    _chatRepository.privateChat(currentUserId, userId);
  }

  Stream<RoomState> _mapToRemoveUser(RemoveUser event) async* {
    await _chatRepository.toRemoveUser(state.room.id!, event.userId);
    add(GetRoom(roomId: state.room.id!));
  }

  String currentUserId() {
    return _authBloc.state.user!.uid;
  }

  void deleteRoom(String roomId) {
    _chatRepository.toDeleteRoom(roomId);
  }

  void deleteMessage(String messageId) {
    _chatRepository.deleteMessage(
        state.room.id!, messageId, Paths.rooms, Paths.messages);
  }

  Stream<RoomState> _mapToUploadChatImage(UploadImage event) async* {
    yield state.copyWith(status: RoomStatus.uploadingImage);
    final pickedFile = await ImageHelper.pickFromGallery(
        context: event.context,
        cropStyle: CropStyle.rectangle,
        title: "Discussion Image");

    if (pickedFile != null) {
      final rImage = await _storageRepository.uploadProfileImage(
          url: null, image: pickedFile);
      yield state.copyWith(image: rImage, status: RoomStatus.uploadedImage);
    } else {
      yield state.copyWith(status: RoomStatus.initial);
    }
  }

  Stream<RoomState> _mapToClearSearch(ClrSearch event) async* {
    yield state.copyWith(image: '');
  }

  Future<bool> chatExists(String userId) async {
    final currentUserId = _authBloc.state.user!.uid;
    return await _chatRepository.privateChatExists(currentUserId, userId);
  }

  Stream<RoomState> _mapToChangeView(ChangeView event) async* {
    yield state.copyWith(
      selectedIndex: event.index,
    );
  }

  void postLike() async {
    print('+++++++++++++++++++++++++++++++');
    final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid, posts: state.posts);
    _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
  }
}
