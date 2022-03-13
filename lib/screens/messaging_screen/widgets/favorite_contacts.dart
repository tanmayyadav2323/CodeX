import 'package:code/models/user_model.dart';
import 'package:flutter/material.dart';

import '../chat_screen.dart';

class FavoriteContacts extends StatefulWidget {
  FavoriteContacts({Key? key}) : super(key: key);

  @override
  State<FavoriteContacts> createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  final List<User> favorites = [
    const User(
        id: '0',
        username: 'aaa',
        name: 'Tanmay',
        skills: 'skills',
        linkedIn: 'linkedIn',
        github: 'github',
        profileImageUrl:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
    const User(
      id: '0',
      username: 'aaa',
      name: 'Akhil',
      skills: 'skills',
      linkedIn: 'linkedIn',
      github: 'github',
      profileImageUrl:
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
    ),
    const User(
      id: '0',
      username: 'aaa',
      name: 'Golu',
      skills: 'skills',
      linkedIn: 'linkedIn',
      github: 'github',
      profileImageUrl:
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
    ),
    const User(
        id: '0',
        username: 'aaa',
        name: 'Tanmay',
        skills: 'skills',
        linkedIn: 'linkedIn',
        github: 'github',
        profileImageUrl:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
    const User(
      id: '0',
      username: 'aaa',
      name: 'Akhil',
      skills: 'skills',
      linkedIn: 'linkedIn',
      github: 'github',
      profileImageUrl:
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
    ),
    const User(
      id: '0',
      username: 'aaa',
      name: 'Golu',
      skills: 'skills',
      linkedIn: 'linkedIn',
      github: 'github',
      profileImageUrl:
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
    )
  ];

  bool _showFavoriteContacts = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showFavoriteContacts = !_showFavoriteContacts;
                    });
                  },
                  icon: const Icon(Icons.more_horiz),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                )
              ],
            ),
          ),
          _showFavoriteContacts
              ? Container(
                  height: 130.0,
                  child: ListView.builder(
                    itemCount: favorites.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 10.0),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(ChatScreen.routeName),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 35.0,
                                backgroundImage: NetworkImage(
                                    favorites[index].profileImageUrl!),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                favorites[index].name,
                                style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
