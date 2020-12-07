import 'package:flutter/material.dart';

class NewMessageIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.mail_outline_rounded),
          ),
          onPressed: () {},
        ),
        Positioned(
          right: 14,
          top: 13,
          child: CircleAvatar(
            maxRadius: 6,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
