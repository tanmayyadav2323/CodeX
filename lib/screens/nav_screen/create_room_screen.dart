import 'package:code/blocs/blocs.dart';
import 'package:code/models/models.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/editprofile_bloc.dart';

class CreateRoomScreen extends StatelessWidget {
  static const routeName = 'create_room_screen';
  const CreateRoomScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditprofileBloc>(
        create: (_) => EditprofileBloc(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          authBloc: context.read<AuthBloc>(),
          authRepository: context.read<AuthRepository>(),
          chatRepository: context.read<ChatRepository>(),
        )..add(const ClearRoomImage()),
        child: const CreateRoomScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _roomName = TextEditingController();
    TextEditingController _bio = TextEditingController();

    return BlocConsumer<EditprofileBloc, EditprofileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create Room'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      state.status == EditprofileStatus.uploadingRoomImage
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                              child: state.roomImage == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 200,
                                    )
                                  : Container(
                                      height: 300,
                                      width: 300,
                                      child: Image.network(
                                        state.roomImage!,
                                        fit: BoxFit.contain,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                              onTap: () {
                                context
                                    .read<EditprofileBloc>()
                                    .add(UploadRoomImage(context: context));
                              },
                            ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Room Name'),
                        ),
                        controller: _roomName,
                        validator: (value) {
                          if (value!.trim().isEmpty) return 'Enter Room';
                          return null;
                        },
                        maxLength: 100,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Bio'),
                        ),
                        controller: _bio,
                        validator: (value) {
                          if (value!.trim().isEmpty) return 'Enter Bio';
                          return null;
                        },
                        minLines: 3,
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            if (state.roomImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Upload Image')),
                              );
                            } else {
                              context.read<EditprofileBloc>().add(
                                    CreateRoom(
                                      room: Room(
                                          name: _roomName.text,
                                          creatorId: '',
                                          creatorName: '',
                                          bio: _bio.text,
                                          imageUrl: state.roomImage!,
                                          numofMembers: 0,
                                          memberIds: []),
                                    ),
                                  );
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Text('Create Room'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
