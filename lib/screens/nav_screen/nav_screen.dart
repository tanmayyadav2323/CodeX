import 'dart:io';

import 'package:code/blocs/auth/auth_bloc.dart';
import 'package:code/helpers/image_helper.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/screens/messaging_screen/message_screen.dart';
import 'package:code/screens/nav_screen/bloc/editprofile_bloc.dart';
import 'package:code/screens/nav_screen/widgets/user_profile.dart';

import 'package:code/utils/utils.dart';
import 'package:code/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/rooms_card.dart';

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
    final size = MediaQuery.of(context).size;
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
            appBar: AppBar(
              elevation: 0,
              title: const Text('CODE'),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Center(
                      child: UserProfile(
                        image: state.image,
                        profileImageurl: state.profileImageurl,
                        radius: size.height * 0.05,
                        name: state.name,
                        fontSize: size.height * 0.025,
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
            body: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      height: size.height * 0.1,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(1),
                          hintText: 'Search for rooms',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: const Icon(Icons.clear_rounded),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.08,
                    left: size.width * 0.035,
                    right: size.width * 0.035,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: const [
                        RoomCard(
                          roomName: "BlockChain",
                          bio: "Hurry Up bloackchain People Join now",
                          numOfPeople: 200,
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRU_vEQqsrl46FtarbCW-L518avHjgAUPBlHw&usqp=CAU",
                        ),
                        RoomCard(
                          roomName: "Competitive Programming",
                          bio:
                              "Hurry up people with competitive skills joim=n now ",
                          numOfPeople: 450,
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKa-kPsTDUACR7EcY_-e3BgHX_e9UnghKxmw&usqp=CAU",
                        ),
                        RoomCard(
                          roomName: "DSA",
                          bio:
                              "Hurry up people with DSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ",
                          numOfPeople: 450,
                          imageUrl:
                              "https://image.shutterstock.com/image-vector/dsa-creative-logo-monogram-white-260nw-1835276254.jpg",
                        ),
                        RoomCard(
                          roomName: "BlockChain",
                          bio: "Hurry Up bloackchain People Join now",
                          numOfPeople: 200,
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRU_vEQqsrl46FtarbCW-L518avHjgAUPBlHw&usqp=CAU",
                        ),
                        RoomCard(
                          roomName: "Competitive Programming",
                          bio:
                              "Hurry up people with competitive skills joim=n now ",
                          numOfPeople: 450,
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKa-kPsTDUACR7EcY_-e3BgHX_e9UnghKxmw&usqp=CAU",
                        ),
                        RoomCard(
                          roomName: "DSA",
                          bio:
                              "Hurry up people with DSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ",
                          numOfPeople: 450,
                          imageUrl:
                              "https://image.shutterstock.com/image-vector/dsa-creative-logo-monogram-white-260nw-1835276254.jpg",
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * 0.1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.1, 0.9],
                          colors: [
                            const Color(0xffF1EFE5).withOpacity(0.2),
                            const Color(0xffF1EFE5),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: () {},
                            label: const Text(
                              "Create Room",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            icon: const Icon(Icons.add),
                            elevation: 10,
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff88D198),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(MessagingScreen.routeName);
                            },
                            child: Icon(
                              Icons.message,
                              size: size.height * 0.035,
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              shape: CircleBorder(),
                              primary: Color(0xff88D198),
                              
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Drawer _buildDrawer(EditprofileState state, BuildContext context) {
  final size = MediaQuery.of(context).size;
  final usernameController = TextEditingController();

  return Drawer(
    child: state.status == EditprofileStatus.submitting
        ? Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LinearProgressIndicator(),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Text(
                  'Saving',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.03),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: size.height * 0.01,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          GestureDetector(
                            child: Center(
                              child: UserProfile(
                                image: state.image,
                                profileImageurl: state.profileImageurl,
                                radius: size.height * 0.1,
                                name: state.name,
                                fontSize: size.height * 0.09,
                              ),
                            ),
                            onTap: () {
                              _selectProfileImage(context);
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.02,
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
                              enabledBorder: InputBorder.none,
                              hintText: 'Enter name',
                              hintStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                          TextFormField(
                            controller: usernameController,
                            onChanged: (value) async {
                              context
                                  .read<EditprofileBloc>()
                                  .add(ProfileUsernameChanged(username: value));
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter username',
                              hintStyle: const TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                              prefix: const Text("@",
                                  style: TextStyle(color: Colors.white)),
                              suffixIconConstraints:
                                  const BoxConstraints(maxHeight: 30),
                              suffixIcon: CircleAvatar(
                                child: Icon(
                                  state.status ==
                                              EditprofileStatus
                                                  .userNameExists ||
                                          state.username.length < 6
                                      ? Icons.close
                                      : Icons.check,
                                ),
                              ),
                              errorStyle: const TextStyle(
                                  color: scaffoldBackgroundColor),
                              errorText: state.username.length < 6
                                  ? 'Username Should be more than five digits'
                                  : state.status ==
                                          EditprofileStatus.userNameExists
                                      ? 'Username Exists'
                                      : null,
                              contentPadding: const EdgeInsets.only(top: 0),
                              enabledBorder: InputBorder.none,
                            ),
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
                      margin: EdgeInsets.all(size.height * 0.015),
                      padding: EdgeInsets.all(size.height * 0.015),
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
                          onPressed: () async {
                            final check = await context
                                .read<EditprofileBloc>()
                                .usernameExists(usernameController.text);
                            if (usernameController.text == '') {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                  content: Text('Username Cannot be empty'),
                                ),
                              );
                            } else if (check) {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                  content: Text('Username Already Exists'),
                                ),
                              );
                            } else {
                              context
                                  .read<EditprofileBloc>()
                                  .add(const ProfileUpdateEvent());
                            }
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
                        "Note : The above info given is visible to other users",
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
