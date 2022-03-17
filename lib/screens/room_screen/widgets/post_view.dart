import 'package:cached_network_image/cached_network_image.dart';
import 'package:code/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:code/extensions/date_time_extension.dart';
import 'package:code/models/post_model.dart';
import 'package:code/widgets/user_all_info_profile.dart';
import 'package:code/widgets/user_profile.dart';
import 'package:url_launcher/url_launcher.dart';

class PostView extends StatefulWidget {
  final Post post;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;
  final bool isMe;
  final Function() onTap;

  const PostView({
    Key? key,
    required this.post,
    required this.isLiked,
    required this.onLike,
    this.recentlyLiked = false,
    required this.isMe,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => buildUserAllInfoProfile(
                        context: context,
                        name: widget.post.author.name,
                        imageUrl: widget.post.author.profileImageUrl,
                        linkedIn: widget.post.author.linkedIn,
                        gitHub: widget.post.author.github,
                        skills: widget.post.author.skills,
                      ),
                      child: UserProfile(
                        radius: 20,
                        name: widget.post.author.name,
                        profileImageurl: widget.post.author.profileImageUrl,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      widget.post.author.username,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                !widget.isMe
                    ? _buildDropDown('Chat', widget.onTap)
                    : _buildDropDown('Delete', widget.onTap)
              ],
            ),
          ),
        ),
        if (widget.post.imageUrl != '')
          GestureDetector(
            onDoubleTap: widget.onLike,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.post.imageUrl,
                  height: MediaQuery.of(context).size.height / 2.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        if (widget.post.caption.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(widget.post.caption),
          ),
        if (widget.post.link.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                await launch(
                  widget.post.link,
                  forceSafariVC: true,
                  forceWebView: true,
                  headers: <String, String>{'my_header_key': 'my_header_value'},
                );
              },
              child: SingleChildScrollView(
                child: Text(
                  widget.post.link,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        Row(
          children: [
            IconButton(
              onPressed: widget.onLike,
              icon: widget.isLiked
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_outline,
                    ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CommentsScreen.routeName,
                    arguments: CommentsScreenArgs(post: widget.post));
              },
              icon: Icon(Icons.comment_outlined),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${widget.recentlyLiked ? widget.post.likes + 1 : widget.post.likes} likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.post.date.timeAgo(),
                  style: TextStyle(
                      color: Colors.grey[400], fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }
}

_buildDropDown(String val, Function() onTap) {
  return DropdownButton(
    items: [val].map((String value) {
      return DropdownMenuItem<String>(
        onTap: onTap,
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: (value) {},
  );
}
