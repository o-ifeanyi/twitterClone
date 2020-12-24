import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SearchScreen extends StatelessWidget {
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
        title: Container(
          padding: const EdgeInsets.only(left: 15),
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Twitter',
              border: InputBorder.none,
            ),
          ),
        ),
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
          ),
        ],
      ),
    );
  }
}
