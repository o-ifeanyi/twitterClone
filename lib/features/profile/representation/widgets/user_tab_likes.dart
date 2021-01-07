import 'package:flutter/material.dart';

class UserTabLikes extends StatefulWidget {
  final String userId;

  UserTabLikes({@required this.userId});
  @override
  _UserTabLikesState createState() => _UserTabLikesState();
}

class _UserTabLikesState extends State<UserTabLikes> {
  @override
  void initState() {
    super.initState();
    print('likes');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('four'),
    );
  }
}
