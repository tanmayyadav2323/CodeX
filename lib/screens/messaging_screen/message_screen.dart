import 'package:code/blocs/auth/auth_bloc.dart';
import 'package:code/models/private_chat_model.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/screens/messaging_screen/bloc/message_bloc.dart';
import 'package:code/screens/messaging_screen/chat_screen.dart';
import 'package:code/screens/messaging_screen/search/search_screen.dart';
import 'package:code/screens/messaging_screen/widgets/favorite_contacts.dart';
import 'package:code/utils/firebase_constants.dart';
import 'package:code/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagingScreen extends StatefulWidget {
  static const routeName = '/messaging_screen';

  const MessagingScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<MessageBloc>(
        create: (_) => MessageBloc(
          authBloc: context.read<AuthBloc>(),
          chatRepository: context.read<ChatRepository>(),
          storageRepository: context.read<StorageRepository>(),
        ),
        child: const MessagingScreen(),
      ),
    );
  }

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MessageBloc>().add(PrivateChatFetch());
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
            icon: const Icon(Icons.search),
            iconSize: 30.0,
          ),
        ],
      ),
      body: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state.status == MessageStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Column(
              children: [
                FavoriteContacts(),
                SizedBox(
                  height: 50,
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [Text("Private"), Text("Groups")],
                    indicatorWeight: 3.0,
                    onTap: (i) {
                      context
                          .read<MessageBloc>()
                          .add(PrivateChatView(isPrivate: i == 0));
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: state.isPrivate
                        ? privateChats(context, state)
                        : groupChats(context, state),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

groupChats(BuildContext context, MessageState state) {
  return Container();
}

privateChats(BuildContext context, MessageState state) {
  final size = MediaQuery.of(context).size;
  List<PrivateChat?> chats = state.privateChats;
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0),
    ),
    child: ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Dismissible(
          key: Key(chat!.id!),
          background: Container(
            padding: const EdgeInsets.all(30),
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Icon(
              Icons.delete,
            ),
          ),
          onDismissed: (direction) {
            context.read<MessageBloc>().deleteChat(chat.id!);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 3),
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: context.read<MessageBloc>().isRead(chat) == false
                  ? const Color(0xFFFFEFEE)
                  : Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      ChatScreen.routeName,
                      arguments: ChatScreenArgs(chat: chat)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => buildUserAllInfoProfile(
                            context: context,
                            name: chat.name,
                            imageUrl: chat.imageUrl,
                            linkedIn: chat.linkedIn,
                            gitHub: chat.gitHub,
                            skills: chat.skills),
                        child: UserProfile(
                          radius: 30,
                          name: chat.name!,
                          profileImageurl: chat.imageUrl,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.name!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              chat.recentMessage!,
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            timeFormat.format(chat.recentTimestamp!.toDate()),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 7.0,
                          ),
                          context.read<MessageBloc>().isRead(chat) == false
                              ? Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  width: 40,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
