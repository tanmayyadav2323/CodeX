import 'package:code/screens/nav_screen/widgets/rooms_card.dart';
import 'package:flutter/material.dart';

class NavScreen extends StatefulWidget {
  static const routename = 'nav_screen';
  const NavScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routename),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => const NavScreen(),
    );
  }

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xffF1EFE5),
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xffBCDEC3),
            title: const Text(
              'CODE',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const CircleAvatar(
                    child: Text(
                      'T',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Color(0xffFFFFFF),
                  ))
            ],
          ),
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
                    bio: "Hurry up people with competitive skills joim=n now ",
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
                    bio: "Hurry up people with competitive skills joim=n now ",
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
          floatingActionButton: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xffF1EFE5), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Create Room'),
                  IconButton(
                    icon: Image.asset(
                      'assets/Icons/message.jpg',
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {},
                  ),
                ]),
          ),
        ));
  }
}
