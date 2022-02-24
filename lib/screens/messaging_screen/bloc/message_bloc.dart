import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code/blocs/auth/auth_bloc.dart';
import 'package:code/models/failure_model.dart';
import 'package:code/models/private_chat_model.dart';
import 'package:code/models/user_model.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final AuthBloc _authBloc;
  final ChatRepository _chatRepository;
  StreamSubscription<List<Future<PrivateChat?>>>? _privateChatSubscription;

  MessageBloc(
      {required AuthBloc authBloc, required ChatRepository chatRepository})
      : _authBloc = authBloc,
        _chatRepository = chatRepository,
        super(MessageState.initial());

  @override
  Future<void> close() {
    _privateChatSubscription!.cancel();
    return super.close();
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is PrivateChatFetch) {
      yield* _mapPrivateChatFetchToState(event);
    } else if (event is UpdateChats) {
      yield* _mapUpdateChatsToState(event);
    }
  }

  Stream<MessageState> _mapPrivateChatFetchToState(
      PrivateChatFetch event) async* {
    yield state.copyWith(status: MessageStatus.initial);
    try {
      final currentUserId = _authBloc.state.user!.uid;
      _privateChatSubscription =
          _chatRepository.getPrivateChats(currentUserId).listen((chats) async {
        final allChats = await Future.wait(chats);
        add(UpdateChats(privateChats: allChats));
      });
      yield state.copyWith(status: MessageStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: MessageStatus.error,
        failure: const Failure(
          message: 'Unable To Fetch Chats',
        ),
      );
    }
  }

  Stream<MessageState> _mapUpdateChatsToState(UpdateChats event) async* {
    yield state.copyWith(privateChats: event.privateChats);
  }
}
