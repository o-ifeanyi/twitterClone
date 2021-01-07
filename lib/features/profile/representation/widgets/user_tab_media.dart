import 'package:flutter/material.dart';

class UserTabMedias extends StatefulWidget {
  final String userId;

  UserTabMedias({@required this.userId});
  @override
  _UserTabMediasState createState() => _UserTabMediasState();
}

class _UserTabMediasState extends State<UserTabMedias> {
  @override
  void initState() {
    super.initState();
    print('medias');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('three'),
    );
  }
}
