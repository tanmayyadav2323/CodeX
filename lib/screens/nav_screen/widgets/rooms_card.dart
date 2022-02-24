import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String bio;
  final String imageUrl;
  final int numOfPeople;

  const RoomCard(
      {Key? key,
      required this.roomName,
      required this.bio,
      required this.imageUrl,
      required this.numOfPeople})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              height: 130,
              width: 130,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 210,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      roomName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    bio,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person),
                      Text(
                        numOfPeople.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
