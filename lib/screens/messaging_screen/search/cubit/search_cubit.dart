import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:code/blocs/auth/auth_bloc.dart';
import 'package:code/models/models.dart';
import 'package:code/models/user_model.dart';
import 'package:code/repositories/chat/chat_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ChatRepository _chatRepository;
  final AuthBloc _authBloc;

  SearchCubit({
    required ChatRepository chatRepository,
    required AuthBloc authBloc,
  })  : _chatRepository = chatRepository,
        _authBloc = authBloc,
        super(SearchState.initial());

  void searchUser({required String query}) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final userId = _authBloc.state.user!.uid;
      final users = await _chatRepository.searchUser(userId, query);
      emit(state.copyWith(users: users, status: SearchStatus.loaded));
    } catch (err) {
      state.copyWith(
        status: SearchStatus.error,
        failure: const Failure(message: 'Something went wrong'),
      );
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchStatus.initial));
  }

  void createChat(String userId) {
    final currentUserId = _authBloc.state.user!.uid;
    _chatRepository.privateChat(currentUserId, userId);
  }
}
