import 'dart:io';

import 'package:code/blocs/auth/auth_bloc.dart';
import 'package:code/helpers/image_helper.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/screens/nav_screen/bloc/editprofile_bloc.dart';
import 'package:code/screens/nav_screen/widgets/rooms_card.dart';
import 'package:code/screens/nav_screen/widgets/user_profile.dart';
import 'package:code/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:url_launcher/url_launcher.dart';

class NavScreen extends StatefulWidget {
  static const routename = 'nav_screen';
  const NavScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routename),
      builder: (context) => BlocProvider<EditprofileBloc>(
        create: (_) => EditprofileBloc(
            userRepository: context.read<UserRepository>(),
            storageRepository: context.read<StorageRepository>(),
            authBloc: context.read<AuthBloc>(),
            authRepository: context.read<AuthRepository>()),
        child: const NavScreen(),
      ),
    );
  }

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<EditprofileBloc>().add(const ProfileLoadUserEvent());
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<EditprofileBloc, EditprofileState>(
        listener: (context, state) {
          if (state.status == EditprofileStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color(0xffF1EFE5),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xffBCDEC3),
              title: const Text(
                'CODE',
                style: TextStyle(color: Colors.black),
              ),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Center(
                      child: UserProfile(
                        image: state.image,
                        profileImageurl: state.profileImageurl,
                        radius: 20,
                        name: state.name,
                        fontSize: 10,
                      ),
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
            ),
            drawer: _buildDrawer(state, context),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      height: 65,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(1),
                          hintText: 'Search for rooms',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: const Icon(
                            Icons.clear_rounded,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    const RoomCard(
                      roomName: "BlockChain",
                      bio: "Hurry Up bloackchain People Join now",
                      numOfPeople: 200,
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRU_vEQqsrl46FtarbCW-L518avHjgAUPBlHw&usqp=CAU",
                    ),
                    const RoomCard(
                      roomName: "Competitive Programming",
                      bio:
                          "Hurry up people with competitive skills joim=n now ",
                      numOfPeople: 450,
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKa-kPsTDUACR7EcY_-e3BgHX_e9UnghKxmw&usqp=CAU",
                    ),
                    const RoomCard(
                      roomName: "DSA",
                      bio:
                          "Hurry up people with DSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ",
                      numOfPeople: 450,
                      imageUrl:
                          "https://image.shutterstock.com/image-vector/dsa-creative-logo-monogram-white-260nw-1835276254.jpg",
                    ),
                    const RoomCard(
                      roomName: "Artificial Intelligence",
                      bio:
                          "hURRY UP JOIN ARTIFICIAL INTELLIGENCE GROUP NOW...................",
                      numOfPeople: 500,
                      imageUrl:
                          "https://static.scientificamerican.com/sciam/cache/file/B5EEA99B-9A70-44CC-B41AFC2EF100377A.jpg",
                    ),
                    const RoomCard(
                      roomName: "BlockChain",
                      bio: "Hurry Up bloackchain People Join now",
                      numOfPeople: 200,
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRU_vEQqsrl46FtarbCW-L518avHjgAUPBlHw&usqp=CAU",
                    ),
                    const RoomCard(
                      roomName: "Competitive Programming",
                      bio:
                          "Hurry up people with competitive skills joim=n now ",
                      numOfPeople: 450,
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKa-kPsTDUACR7EcY_-e3BgHX_e9UnghKxmw&usqp=CAU",
                    ),
                    const RoomCard(
                      roomName: "DSA",
                      bio:
                          "Hurry up people with DSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ",
                      numOfPeople: 450,
                      imageUrl:
                          "https://image.shutterstock.com/image-vector/dsa-creative-logo-monogram-white-260nw-1835276254.jpg",
                    ),
                    const RoomCard(
                      roomName: "Artificial Intelligence",
                      bio:
                          "hURRY UP JOIN ARTIFICIAL INTELLIGENCE GROUP NOW...................",
                      numOfPeople: 500,
                      imageUrl:
                          "https://static.scientificamerican.com/sciam/cache/file/B5EEA99B-9A70-44CC-B41AFC2EF100377A.jpg",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Drawer _buildDrawer(EditprofileState state, BuildContext context) {
  return Drawer(
    child: state.status == EditprofileStatus.submitting
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LinearProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Saving',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )
              ],
            ),
          )
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            child: Center(
                              child: UserProfile(
                                image: state.image,
                                profileImageurl: state.profileImageurl,
                                radius: 80,
                                name: state.name,
                                fontSize: 60,
                              ),
                            ),
                            onTap: () {
                              _selectProfileImage(context);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: state.name,
                            onChanged: (value) {
                              context
                                  .read<EditprofileBloc>()
                                  .add(ProfileNameChanged(name: value));
                            },
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 0),
                                enabledBorder: InputBorder.none),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                          TextFormField(
                            initialValue: state.username,
                            validator: (value) {},
                            onChanged: (value) {
                              context
                                  .read<EditprofileBloc>()
                                  .add(ProfileUsernameChanged(username: value));
                            },
                            decoration: const InputDecoration(
                                prefix: Text("@",
                                    style: TextStyle(color: Colors.white)),
                                contentPadding: EdgeInsets.only(top: 0),
                                enabledBorder: InputBorder.none),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "About",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(),
                          const Text(
                            "Skills",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            initialValue: state.skills,
                            onChanged: (value) {
                              context
                                  .read<EditprofileBloc>()
                                  .add(ProfileSkillsChanged(skills: value));
                            },
                            decoration: const InputDecoration(
                                enabledBorder: InputBorder.none),
                            maxLines: 3,
                            minLines: 1,
                          ),
                          const Divider(),
                          const Text(
                            "Linked In",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            initialValue: state.linkedIn,
                            onChanged: (value) {
                              context
                                  .read<EditprofileBloc>()
                                  .add(ProfileLinkedInChanged(linkedIn: value));
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              prefixIcon: IconButton(
                                onPressed: () async {
                                  await launch(
                                    state.linkedIn,
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
                            maxLines: 1,
                            keyboardType: TextInputType.url,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const Divider(),
                          const Text(
                            "Github",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            initialValue: state.github,
                            onChanged: (value) {
                              context
                                  .read<EditprofileBloc>()
                                  .add(ProfileGithubChanged(github: value));
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              prefixIcon: IconButton(
                                onPressed: () async {
                                  await launch(
                                    state.github,
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
                            maxLines: 1,
                            keyboardType: TextInputType.url,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<EditprofileBloc>()
                                .add(const ProfileUpdateEvent());
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.save),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Save"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: () {
                            context
                                .read<EditprofileBloc>()
                                .add(const ProfileLogOutEvent());
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Log Out"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Note : Other users will be able to see the above information",
                        style: TextStyle(fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
  );
}

void _selectProfileImage(BuildContext context) async {
  final pickedFile = await ImageHelper.pickFromGallery(
      context: context, cropStyle: CropStyle.circle, title: "Profile Image");

  if (pickedFile != null) {
    context.read<EditprofileBloc>().add(
          ProfileImageChanged(
            image: File(pickedFile.path),
          ),
        );
  }
}


            // floatingActionButton: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     FloatingActionButton.extended(
            //       onPressed: () {},
            //       label: const Text(
            //         "Create Room",
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            //       ),
            //       icon: const Icon(Icons.add),
            //       elevation: 10,
            //       foregroundColor: Colors.white,
            //       backgroundColor: const Color(0xff88D198),
            //     ),
            //     FloatingActionButton(
            //       onPressed: () {},
            //       child: const Icon(
            //         Icons.message,
            //         size: 30,
            //       ),
            //       elevation: 10,
            //       backgroundColor: const Color(0xff88D198),
            //     )
            //   ],
            // ),