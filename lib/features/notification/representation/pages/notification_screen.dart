import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          snap: true,
          floating: true,
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          title: Text('Notifications',
              style: Theme.of(context).textTheme.headline6),
          actions: [
            IconButton(
                icon: Icon(
                  AntDesign.setting,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {}),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(
                height: 1000,
              )
            ],
          ),
        ),
      ],
    );
  }
}
