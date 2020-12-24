import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Foundation.list, color: Theme.of(context).primaryColor),
        ),
        title: Text('Messages', style: Theme.of(context).textTheme.headline6),
        actions: [
          IconButton(
              icon: Icon(
                AntDesign.setting,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 1000,
          )
        ],
      ),
    );
  }
}
