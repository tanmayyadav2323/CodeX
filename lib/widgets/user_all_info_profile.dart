import 'package:code/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> buildUserAllInfoProfile({
  required BuildContext context,
  String? name,
  String? imageUrl,
  String? linkedIn,
  String? skills,
  String? gitHub,
}) {
  final size = MediaQuery.of(context).size;
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(name!),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfile(
              radius: size.height * 0.15,
              name: name,
              fontSize: size.height * 0.09,
              profileImageurl: imageUrl,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              width: double.infinity,
              padding: EdgeInsets.all(size.height * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    "Skills",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(skills!),
                  const Divider(),
                  Text(
                    "LinkedIn",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  otherNetworkLink(linkedIn),
                  const Divider(),
                  Text(
                    "GitHub",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  otherNetworkLink(gitHub),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget otherNetworkLink(String? name) {
  return GestureDetector(
    onTap: () async {
      await launch(
        name!,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    },
    child: SingleChildScrollView(
      child: Text(
        name!,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
      scrollDirection: Axis.horizontal,
    ),
  );
}
