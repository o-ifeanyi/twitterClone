
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class TweetEntity extends Equatable {
  final String name;
  final String userName;
  final String message;
  final dynamic timeStamp;

  TweetEntity({
    @required this.name,
    @required this.userName,
    @required this.message,
    @required this.timeStamp,
  });

  @override
  List<Object> get props => [name, userName, message, timeStamp];
}