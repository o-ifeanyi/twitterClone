import 'package:flutter/material.dart';

class UserTabReplies extends StatefulWidget {
  final String userId;

  UserTabReplies({@required this.userId});
  @override
  _UserTabRepliesState createState() => _UserTabRepliesState();
}

class _UserTabRepliesState extends State<UserTabReplies> {
  @override
  void initState() {
    super.initState();
    print('replies');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('two'),
    );
  }
}
