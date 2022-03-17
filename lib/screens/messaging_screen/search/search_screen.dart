import 'package:code/blocs/blocs.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SearchCubit>(
        create: (_) => SearchCubit(
          chatRepository: context.read<ChatRepository>(),
          authBloc: context.read<AuthBloc>(),
        ),
        child: const SearchScreen(),
      ),
    );
  }

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                hintText: 'Search Username',
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SearchCubit>().clearSearch();
                    _textEditingController?.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                context.read<SearchCubit>().clearSearch();
                if (value.trim().isNotEmpty) {
                  context.read<SearchCubit>().searchUser(query: value.trim());
                }
              },
            ),
          ),
          body: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              switch (state.status) {
                case SearchStatus.error:
                  return Center(
                    child: Text(
                      state.failure.message,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                case SearchStatus.initial:
                  return Center(
                    child: Text(
                      "Search and Connect With People",
                      maxLines: 2,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                case SearchStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case SearchStatus.loaded:
                  return state.users.isNotEmpty
                      ? ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            final user = state.users[index];
                            return ListTile(
                              leading: UserProfile(
                                radius: 20,
                                name: user.name,
                                profileImageurl: user.profileImageUrl,
                              ),
                              title: Text(
                                user.username,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                return buildUserAllInfoProfile(
                                  context: context,
                                  name: user.name,
                                  gitHub: user.github,
                                  imageUrl: user.profileImageUrl,
                                  linkedIn: user.linkedIn,
                                  skills: user.skills,
                                );
                              },
                              trailing: ElevatedButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();

                                    final chatExists = await context
                                        .read<SearchCubit>()
                                        .chatExists(user.id);

                                    chatExists
                                        ? context
                                            .read<SearchCubit>()
                                            .createChat(user.id)
                                        : null;

                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          chatExists
                                              ? 'Chat Created'
                                              : 'Chat Exists',
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: const Text('message')),
                            );
                          },
                          itemCount: state.users.length)
                      : Center(
                          child: Text(
                            "No Users Found",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        );
                default:
                  return const SizedBox.shrink();
              }
            },
          )),
    );
  }
}
