import 'dart:io';

import 'package:code/blocs/blocs.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/utils/firebase_constants.dart';
import 'package:code/widgets/user_all_info_profile.dart';
import 'package:code/widgets/user_profile.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:code/models/message_model.dart';
import 'package:code/models/private_chat_model.dart';
import 'package:code/utils/theme_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/message_bloc.dart';

class ChatScreenArgs {
  final PrivateChat chat;
  ChatScreenArgs({
    required this.chat,
  });
}

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat_screen';

  static Route route({required ChatScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<MessageBloc>(
        create: (_) => MessageBloc(
            authBloc: context.read<AuthBloc>(),
            chatRepository: context.read<ChatRepository>(),
            storageRepository: context.read<StorageRepository>())
          ..add(GetMessage(chatId: args.chat.id!))
          ..add(const EmojiShowing(emojiShowing: false)),
        child: ChatScreen(chat: args.chat),
      ),
    );
  }

  final PrivateChat chat;
  const ChatScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController? controller;

  @override
  void initState() {
    controller = TextEditingController();
    context.read<MessageBloc>().setChatRead(widget.chat.id!, true);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appBarBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(size.height * 0.01),
              child: UserProfile(
                radius: 3,
                name: widget.chat.name!,
                profileImageurl: widget.chat.imageUrl,
                fontSize: 25,
              ),
            ),
            onTap: () => buildUserAllInfoProfile(
              context: context,
              name: widget.chat.name!,
              gitHub: widget.chat.gitHub,
              linkedIn: widget.chat.gitHub,
              imageUrl: widget.chat.imageUrl,
              skills: widget.chat.skills,
            ),
          ),
          title: Text(widget.chat.name!),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.more_horiz,
              ),
              iconSize: size.height * 0.05,
            )
          ],
        ),
        body: BlocConsumer<MessageBloc, MessageState>(
          listener: (context, state) {},
          builder: (context, state) {
            final message = state.messages;
            return Column(
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
                    child: message.isEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.06),
                            child: Column(
                              children: [
                                Text(
                                  'Hey Dude 🖐',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  'Start Chatting',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            width: double.infinity,
                          )
                        : ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top: size.height * 0.05),
                            itemCount: message.length,
                            itemBuilder: (BuildContext context, int index) {
                              final isMe = context
                                  .read<MessageBloc>()
                                  .currentUserMessage(message[index]);
                              return _buildMessage(message[index], isMe);
                            },
                          ),
                  ),
                ),
                _buildSendMessage(state, controller!),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildMessage(Message message, bool isMe) {
    return GestureDetector(
      onLongPress: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text('Delete Message'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<MessageBloc>()
                    .deleteMessage(widget.chat.id!, message.id!);
              },
              child: const Text('Delete'),
            )
          ],
        ),
      ),
      onDoubleTap: () {
        bool liked = !message.isLiked;
        context.read<MessageBloc>().isLike(widget.chat.id!, message.id!, liked);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        margin: isMe
            ? const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 130.0)
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
            const SizedBox(
              height: 4.0,
            ),
            Text(
              timeFormat.format(message.timestamp!.toDate()),
              style: const TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            const SizedBox(
              height: 8.0,
            ),
            message.imageUrl != null
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 250,
                    child: Image.network(message.imageUrl!),
                  )
                : const SizedBox.shrink(),
            if (message.text!.trim().isNotEmpty)
              Text(
                message.text!,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(
              height: 8.0,
            ),
            message.isLiked
                ? const Icon(Icons.favorite, size: 30.0)
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  _buildSendMessage(MessageState state, TextEditingController controller) {
    _onEmojiSelected(Emoji emoji) {
      controller
        ..text += emoji.emoji
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
    }

    _onBackspacePressed() {
      controller
        ..text = controller.text.characters.skipLast(1).toString()
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
    }

    return Column(
      children: [
        if (state.chatImage != null)
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            height: 250,
            child: Image.network(state.chatImage!),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    context
                        .read<MessageBloc>()
                        .add(EmojiShowing(emojiShowing: !state.emojiShowing));
                  },
                  icon: !state.emojiShowing
                      ? const Icon(
                          Icons.emoji_emotions_outlined,
                        )
                      : const Icon(Icons.keyboard),
                ),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    onTap: () {
                      context
                          .read<MessageBloc>()
                          .add(const EmojiShowing(emojiShowing: false));
                    },
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Message',
                    ),
                    maxLines: 5,
                    minLines: 1,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context
                            .read<MessageBloc>()
                            .add(UploadChatImage(context: context));
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (state.chatImage != null || controller.text != '') {
                          context.read<MessageBloc>().sendMessage(
                                text: controller.text,
                                imageUrl: state.chatImage,
                                chatId: widget.chat.id!,
                              );
                          controller.clear();
                          context.read<MessageBloc>().add(ClearSeach());
                        }
                      },
                      child: CircleAvatar(
                        child: const Icon(Icons.send),
                        backgroundColor: Colors.grey[300],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Offstage(
          offstage: !state.emojiShowing,
          child: SizedBox(
            height: 350,
            child: EmojiPicker(
              onEmojiSelected: (Category category, Emoji emoji) {
                _onEmojiSelected(emoji);
              },
              onBackspacePressed: _onBackspacePressed,
              config: Config(
                columns: 7,
                emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                verticalSpacing: 0,
                horizontalSpacing: 0,
                initCategory: Category.RECENT,
                bgColor: const Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                progressIndicatorColor: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                showRecentsTab: true,
                recentsLimit: 28,
                noRecentsText: 'No Recents',
                noRecentsStyle:
                    const TextStyle(fontSize: 20, color: Colors.black26),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
