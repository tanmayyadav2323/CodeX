import 'package:code/blocs/auth/auth_bloc.dart';
import 'package:code/models/private_chat_model.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/screens/messaging_screen/bloc/message_bloc.dart';
import 'package:code/screens/messaging_screen/chat_screen.dart';
import 'package:code/screens/messaging_screen/search/search_screen.dart';
import 'package:code/screens/messaging_screen/widgets/category_selector.dart';
import 'package:code/screens/messaging_screen/widgets/favorite_contacts.dart';
import 'package:code/screens/nav_screen/widgets/user_profile.dart';
import 'package:code/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagingScreen extends StatelessWidget {
  static const routeName = '/messaging_screen';

  const MessagingScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<MessageBloc>(
        create: (_) => MessageBloc(
            authBloc: context.read<AuthBloc>(),
            chatRepository: context.read<ChatRepository>()),
        child: const MessagingScreen(),
      ),
    );
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
              context: (context),
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const CategorySelector(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    children: [FavoriteContacts(), recentChats(context, state)],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

recentChats(BuildContext context, MessageState state) {
  final size = MediaQuery.of(context).size;
  List<PrivateChat?> chats = state.privateChats;
  if (chats == []) {
    const Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return Container(
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: chat!.readStatus == false
                      ? const Color(0xFFFFEFEE)
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(chat.name!),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserProfile(
                                  radius: 140,
                                  name: chat.name!,
                                  fontSize: 70,
                                  profileImageurl: chat.imageUrl,
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  width: double.infinity,
                                  padding: EdgeInsets.all(size.height * 0.015),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "About",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(),
                                      Text(
                                        "Skills",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Text(chat.skills!),
                                      const Divider(),
                                      Text(
                                        "LinkedIn",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await launch(
                                            chat.linkedIn!,
                                            forceSafariVC: true,
                                            forceWebView: true,
                                            headers: <String, String>{
                                              'my_header_key': 'my_header_value'
                                            },
                                          );
                                        },
                                        child: SingleChildScrollView(
                                          child: Text(
                                            chat.linkedIn!,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                      const Divider(),
                                      Text(
                                        "GitHub",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await launch(
                                            chat.linkedIn!,
                                            forceSafariVC: true,
                                            forceWebView: true,
                                            headers: <String, String>{
                                              'my_header_key': 'my_header_value'
                                            },
                                          );
                                        },
                                        child: SingleChildScrollView(
                                          child: Text(
                                            chat.gitHub!,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      child: UserProfile(
                        radius: 30,
                        name: chat.name!,
                        fontSize: 25,
                        profileImageurl: chat.imageUrl,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(ChatScreen.routeName),
                      child: Row(
                        children: [
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
                                child: const Text(
                                  "Hi",
                                  style: TextStyle(
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
                              const Text(
                                '12:00 am',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 7.0,
                              ),
                              // chat.readStatus
                              true
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
              );
            },
          ),
        ),
      ),
    );
  }
}
