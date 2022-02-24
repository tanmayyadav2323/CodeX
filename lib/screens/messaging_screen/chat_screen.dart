import 'package:code/models/message_model.dart';
import 'package:code/utils/theme_constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat_screen';

  const ChatScreen({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ChatScreen(),
    );
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _buildMessage(Message message, bool isMe) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          margin: isMe
              ? const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
              : const EdgeInsets.only(top: 8.0, bottom: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.secondary
                : Colors.lightGreen[50],
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.timestamp.toString(),
                style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                message.text!,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_border_outlined,
          ),
          iconSize: 30.0,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('widgets.user.name'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
            ),
            iconSize: 30.0,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.only(top: 15.0),
                  itemCount: 100,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildMessage(Message(text: "Hi"), false);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
