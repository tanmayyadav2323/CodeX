import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String socialMedia;
  final Function() onPressed;

  AuthButton({required this.socialMedia, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      elevation: 15,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: IconButton(
        onPressed: onPressed,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            Image.asset(
              'assets/Icons/$socialMedia.jpg',
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 20),
            Text(
              'Continue with $socialMedia',
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
