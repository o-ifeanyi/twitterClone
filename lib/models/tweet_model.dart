import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TweetModel {
  final String name;
  final String userName;
  final String message;
  final Timestamp timestamp;

  TweetModel({
    @required this.name,
    @required this.userName,
    @required this.message,
    @required this.timestamp,
  });
}
