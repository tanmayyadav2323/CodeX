import 'dart:io';

import 'package:code/blocs/auth/auth_bloc.dart';
import 'package:code/models/models.dart';
import 'package:code/models/post_model.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/repositories/storage/storage_repository.dart';
import 'package:code/screens/room_screen/create_post/create_post_screen.dart';
import 'package:code/screens/room_screen/room_description.dart';
import 'package:code/screens/room_screen/widgets/post_view.dart';
import 'package:code/screens/room_screen/widgets/widgets.dart';
import 'package:code/screens/screens.dart';
import 'package:code/utils/firebase_constants.dart';
import 'package:code/utils/theme_constants.dart';
import 'package:code/widgets/user_profile.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/room_bloc.dart';
import 'cubits/liked_posts/liked_posts_cubit.dart';

class RoomArgs {
  String roomId;
  RoomArgs({
    required this.roomId,
  });
}

class RoomScreen extends StatefulWidget {
  static const routeName = 'room_screen';

  static Route route({required RoomArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => RoomBloc(
          likedPostsCubit: context.read<LikedPostsCubit>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
          chatRepository: context.read<ChatRepository>(),
          storageRepository: context.read<StorageRepository>(),
        )
          ..add(GetMessages(roomId: args.roomId))
          ..add(GetRoom(roomId: args.roomId))
          ..add(GetPosts(roomId: args.roomId))
          ..postLike(),
        child: RoomScreen(roomId: args.roomId),
      ),
    );
  }

  final String roomId;
  const RoomScreen({Key? key, required this.roomId}) : super(key: key);
  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController controller = TextEditingController();
  int _selectedIndex = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomBloc, RoomState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: CustomAppBar(
                  onTap: () => Navigator.of(context).pushNamed(
                    RoomDescription.routeName,
                    arguments: RoomDesArgs(roomId: widget.roomId),
                  ),
                  appBar: AppBar(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserProfile(
                        name: state.room.name,
                        radius: 8,
                        profileImageurl: state.room.imageUrl,
                      ),
                    ),
                    title: Text(state.room.name),
                    bottom: TabBar(
                      controller: _tabController,
                      labelPadding: EdgeInsets.all(10),
                      tabs: const [
                        Text(
                          'Discussions',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      _buildDiscussionScreen(context, state),
                      _buildSendMessage(
                          state, controller, context, widget.roomId),
                    ],
                  ),
                  _buildPost(state, context)
                ],
              ),
              floatingActionButton: _selectedIndex == 1
                  ? FloatingActionButton(
                      backgroundColor: appBarBackgroundColor,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            CreatePostScreen.routeName,
                            arguments: CreatePostArgs(roomId: widget.roomId));
                      },
                      child: const Icon(
                        Icons.add,
                      ),
                      elevation: 5,
                    )
                  : null),
        );
      },
    );
  }
}

Widget _buildDiscussionScreen(BuildContext context, RoomState state) {
  final size = MediaQuery.of(context).size;
  final messages = state.messages;
  return messages.isEmpty
      ? Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.06),
            child: Column(
              children: [
                Text(
                  'Hey  🖐',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(),
                Text(
                  'Be The First One To Send Message',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            width: double.infinity,
          ),
        )
      : Expanded(
          child: ListView.builder(
            reverse: true,
            padding: EdgeInsets.only(top: size.height * 0.05),
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              final isMe = context
                  .read<RoomBloc>()
                  .currentUserMessage(messages[index].senderId!);
              return _buildMessage(messages[index], isMe, context, state);
            },
          ),
        );
}

_buildMessage(
    Message message, bool isMe, BuildContext context, RoomState state) {
  final member = state.room.memberInfo != null
      ? state.room.memberInfo![message.senderId]
      : '';
  final currentUser = context.read<RoomBloc>();
  return GestureDetector(
    onLongPress: () => currentUser.currentUserMessage(message.senderId!)
        ? showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: const Text('Delete Message'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<RoomBloc>().deleteMessage(message.id!);
                  },
                  child: const Text('Delete'),
                )
              ],
            ),
          )
        : null,
    child: Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.60,
          margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
              Row(
                children: [
                  UserProfile(
                    radius: 12,
                    name: member['name'],
                    profileImageurl: member['imageUrl'],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    member['name'],
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              message.imageUrl != ''
                  ? Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      height: 250,
                      child: Image.network(
                        message.imageUrl!,
                        filterQuality: FilterQuality.low,
                      ),
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
                  : const SizedBox.shrink(),
              Text(
                timeFormat.format(message.timestamp!.toDate()),
                style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    ),
  );
}

_buildSendMessage(RoomState state, TextEditingController controller,
    BuildContext context, String roomId) {
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
      state.image != '' || state.status == RoomStatus.uploadingImage
          ? Container(
              margin: const EdgeInsets.all(10),
              color: Colors.lightGreen[50],
              alignment: Alignment.center,
              height: 250,
              child: state.status == RoomStatus.uploadingImage
                  ? const CircularProgressIndicator()
                  : Image.network(
                      state.image,
                      filterQuality: FilterQuality.low,
                    ),
            )
          : const SizedBox.shrink(),
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
                      .read<RoomBloc>()
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
                        .read<RoomBloc>()
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
                          .read<RoomBloc>()
                          .add(UploadImage(context: context));
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (state.image != '' || controller.text != '') {
                        context.read<RoomBloc>().sendMessage(
                              text: controller.text,
                              imageUrl: state.image,
                              roomId: roomId,
                            );
                        controller.clear();
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

_buildPost(RoomState state, BuildContext context) {
  final posts = state.posts;
  if (posts.isEmpty) {
    return const Center(
      child: Text('No Posts'),
    );
  } else {
    return ListView.builder(
      itemBuilder: (_, index) {
        final isMe =
            context.read<RoomBloc>().currentUserMessage(posts[index].author.id);
        final post = state.posts[index];
        final likedPostsState = context.read<LikedPostsCubit>().state;
        final isLiked = likedPostsState.likedPostIds.contains(post.id);
        // final recentlyLiked =
        //     likedPostsState.recentlyLikedPostIds.contains(post.id);
        return PostView(
          post: post,
          isLiked: isLiked,
          recentlyLiked: false,
          onLike: () {
            if (isLiked) {
              context.read<LikedPostsCubit>().unlikedPost(post: post);
            } else {
              context.read<LikedPostsCubit>().likedPost(post: post);
            }
          },
          isMe: isMe,
          onTap: !isMe
              ? () {
                  _buildChat(context, posts[index].author.id);
                }
              : () {
                  context.read<RoomBloc>().deletePost(posts[index].id!);
                },
        );
      },
      itemCount: posts.length,
    );
  }
}

_buildChat(BuildContext context, String id) async {
  final chatExists = await context.read<RoomBloc>().chatExists(id);
  if (!chatExists) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Chat Exists'),
      duration: Duration(seconds: 2),
    ));
  } else {
    context.read<RoomBloc>().createChat(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Chat Created'),
      duration: Duration(seconds: 2),
    ));
  }
  Navigator.of(context).pushNamed(MessagingScreen.routeName);
}
