import 'package:code/blocs/blocs.dart';
import 'package:code/models/models.dart';
import 'package:code/models/post_model.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/comments_bloc.dart';

class CommentsScreenArgs {
  final Post post;
  const CommentsScreenArgs({required this.post});
}

class CommentsScreen extends StatefulWidget {
  static const String routeName = '/comments';

  const CommentsScreen({Key? key}) : super(key: key);

  static Route route({required CommentsScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CommentsBloc>(
        create: (_) => CommentsBloc(
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(CommentsFetchComments(post: args.post)),
        child: const CommentsScreen(),
      ),
    );
  }

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentsStatus.error) {
          showDialog(
            context: (context),
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: const Text('Comments',
                  style: TextStyle(color: Colors.black))),
          body: ListView.builder(
            padding: const EdgeInsets.only(bottom: 60),
            itemCount: state.comments.length,
            itemBuilder: (BuildContext context, int index) {
              final comment = state.comments[index];
              return ListTile(
                  leading: UserProfile(
                      radius: 22.0,
                      name: comment.author.name,
                      profileImageurl: comment.author.profileImageUrl),
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: comment.author.username,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: comment.content,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMd().add_jm().format(comment.date),
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  ));
            },
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == CommentsStatus.submitting)
                  const LinearProgressIndicator(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentsController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Write a comments...'),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          final content = _commentsController.text.trim();
                          if (content.isNotEmpty) {
                            context
                                .read<CommentsBloc>()
                                .add(CommentsPostComment(content: content));
                            _commentsController.clear();
                          }
                        },
                        icon: const Icon(Icons.send))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
