import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:code/blocs/blocs.dart';
import 'package:code/helpers/image_helper.dart';
import 'package:code/repositories/chat/chat_repository.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/utils/theme_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cubit/create_post_cubit.dart';

class CreatePostArgs {
  final String roomId;
  CreatePostArgs({
    required this.roomId,
  });
}

class CreatePostScreen extends StatefulWidget {
  static const routeName = 'create_post_screen';

  static Route route({required CreatePostArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CreatePostCubit>(
        create: (context) => CreatePostCubit(
          postRepository: context.read<PostRepository>(),
          storageRepository: context.read<StorageRepository>(),
          authBloc: context.read<AuthBloc>(),
        ),
        child: CreatePostScreen(
          roomId: args.roomId,
        ),
      ),
    );
  }

  final String roomId;
  const CreatePostScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create Post'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _selectPostImage(context),
                      child: Container(
                        color: appBarBackgroundColor,
                        child: state.postImage != null
                            ? Image.file(
                                state.postImage!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.image,
                                color: Colors.white,
                                size: 400,
                              ),
                        width: double.infinity,
                        height: 400,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Caption'),
                      minLines: 4,
                      maxLines: 7,
                      onChanged: (value) {
                        context.read<CreatePostCubit>().captionChanged(value);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.url,
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      decoration: InputDecoration(
                        hintText: 'Link',
                        prefixIcon: IconButton(
                          onPressed: () async {
                            await launch(
                              state.link,
                              forceSafariVC: true,
                              forceWebView: true,
                              headers: <String, String>{
                                'my_header_key': 'my_header_value'
                              },
                            );
                          },
                          icon: const Icon(Icons.open_in_browser),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<CreatePostCubit>().linkChanged(value);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      elevation: 1,
                      color: Colors.green[400],
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<CreatePostCubit>().submit(widget.roomId);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void _selectPostImage(BuildContext context) async {
  final pickedFile = await ImageHelper.pickFromGallery(
      context: context, cropStyle: CropStyle.rectangle, title: 'Post Image');

  if (pickedFile != null) {
    context.read<CreatePostCubit>().postImageChanged(File(pickedFile.path));
  }
}
