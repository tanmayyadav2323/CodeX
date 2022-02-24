import 'package:code/blocs/blocs.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/screens/nav_screen/widgets/user_profile.dart';
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
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
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
                    _textEditingController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: (value) {
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
                  return Text(
                    state.failure.message,
                    textAlign: TextAlign.center,
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
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(user.name),
                                  content: UserProfile(
                                    radius: 200,
                                    name: user.name,
                                    fontSize: 100,
                                    profileImageurl: user.profileImageUrl,
                                  ),
                                ),
                              ),
                              trailing: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<SearchCubit>()
                                        .createChat(user.id);
                                  },
                                  child: const Text('Chat')),
                            );
                          },
                          itemCount: state.users.length)
                      : const Text(
                          "No Users Found",
                          textAlign: TextAlign.center,
                        );
                default:
                  return const SizedBox.shrink();
              }
            },
          )),
    );
  }
}
