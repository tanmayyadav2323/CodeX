import 'package:code/blocs/blocs.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/screens/messaging_screen/message_screen.dart';
import 'package:code/screens/nav_screen/nav_screen.dart';
import 'package:code/screens/room_screen/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:code/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/room_bloc.dart';

class RoomDesArgs {
  String roomId;
  RoomDesArgs({
    required this.roomId,
  });
}

class RoomDescription extends StatelessWidget {
  static const routeName = 'room_des_screen';

  static Route route({required RoomDesArgs args}) {
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
          ..add(GetRoom(roomId: args.roomId)),
        child: RoomDescription(roomId: args.roomId),
      ),
    );
  }

  final String roomId;
  const RoomDescription({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Description'),
      ),
      body: BlocConsumer<RoomBloc, RoomState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      height: 200,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: state.room.imageUrl != ''
                            ? Image.network(
                                state.room.imageUrl,
                                fit: BoxFit.fill,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ),
                  Text(
                    state.room.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    state.room.bio,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: "created by - ",
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15),
                          children: [
                            TextSpan(
                              text: state.room.creatorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.room.creationDate != null)
                        Text(
                          DateFormat('yyyy-MM-dd – kk:mm')
                              .format(state.room.creationDate!.toDate()),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 10, left: 10, top: 10),
                    child: Container(
                      color: Colors.white54,
                      padding: const EdgeInsets.all(8),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Num Of Members',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            state.room.numofMembers.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildMembersList(state, context),
                  context
                          .read<RoomBloc>()
                          .currentUserMessage(state.room.creatorId)
                      ? FractionallySizedBox(
                          widthFactor: 1,
                          child: RaisedButton.icon(
                            color: Colors.blue,
                            onPressed: () {
                              context.read<RoomBloc>().deleteRoom(roomId);
                              Navigator.of(context)
                                  .pushReplacementNamed(NavScreen.routename);
                            },
                            label: const Text(
                              'Delete Room',
                            ),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        )
                      : FractionallySizedBox(
                          widthFactor: 1,
                          child: RaisedButton.icon(
                            color: Colors.blue,
                            onPressed: () {
                              final id =
                                  context.read<RoomBloc>().currentUserId();
                              context
                                  .read<RoomBloc>()
                                  .add(RemoveUser(userId: id));
                              Navigator.of(context)
                                  .pushReplacementNamed(NavScreen.routename);
                            },
                            label: const Text(
                              'Exit Group',
                            ),
                            icon: const Icon(Icons.delete, color: Colors.red),
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
}

_buildMembersList(RoomState state, BuildContext context) {
  final memberIds = state.room.memberIds;
  final memberInfo = state.room.memberInfo;
  final creatorId = state.room.creatorId;
  final roomFunc = context.read<RoomBloc>();
  return Container(
    height: 400,
    margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
    color: Colors.white,
    child: ListView.separated(
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) => GestureDetector(
        onLongPress: () {
          if (!roomFunc.currentUserMessage(memberIds[index]) &&
              roomFunc.currentUserMessage(creatorId)) {
            _showDialogBox(
                context,
                state,
                memberIds[index],
                memberInfo![memberIds[index]]['name'],
                memberInfo[memberIds[index]]['imageUrl']);
          }
        },
        child: memberInfo != null
            ? _buildMemberTile(
                memberInfo[memberIds[index]]['name'],
                memberInfo[memberIds[index]]['imageUrl'],
                memberIds[index],
                roomFunc.currentUserMessage(memberIds[index]),
                memberIds[index] == creatorId,
                context,
              )
            : const SizedBox.shrink(),
      ),
      itemCount: memberIds.length,
    ),
  );
}

Widget _buildMemberTile(String name, String? imageUrl, String memberId,
    bool isMe, bool isAdmin, BuildContext context) {
  return ListTile(
    leading: UserProfile(
      radius: 25,
      name: name,
      profileImageurl: imageUrl,
    ),
    title: Row(
      children: [
        Text(name),
        isAdmin
            ? const Card(
                elevation: 3,
                color: Colors.orange,
                margin: EdgeInsets.all(4),
                child: Text(
                  'Admin',
                  style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            : const SizedBox.shrink()
      ],
    ),
    trailing: isMe
        ? const Text(
            'You',
          )
        : ElevatedButton(
            onPressed: () async {
              final chatExists =
                  await context.read<RoomBloc>().chatExists(memberId);
              if (!chatExists) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Chat Exists'),
                  duration: Duration(seconds: 2),
                ));
              } else {
                context.read<RoomBloc>().createChat(memberId);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Chat Created'),
                  duration: Duration(seconds: 2),
                ));
              }
              Navigator.of(context).pushNamed(MessagingScreen.routeName);
            },
            child: const Text('Chat'),
          ),
  );
}

_showDialogBox(BuildContext context, RoomState state, String id, String name,
    String imageUrl) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Row(
        children: [
          UserProfile(
            radius: 25,
            name: name,
            profileImageurl: imageUrl,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(name),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.read<RoomBloc>().add(RemoveUser(userId: id));
            Navigator.of(context).pop();
          },
          child: const Text('Remove'),
        )
      ],
    ),
  );
}
