import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TweetingState extends Equatable {
  @override
  List<Object> get props => [];

  void showSnackBar(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    String message,
    int time, {
    bool isError = false,
  }) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: time),
        backgroundColor: isError
            ? Theme.of(context).errorColor
            : Theme.of(context).primaryColor,
      ),
    );
  }
}

class InitialTweetingState extends TweetingState {}

class SendingError extends TweetingState {
  final String message;

  SendingError({this.message});

  @override
  List<Object> get props => [message];
}

class SendingComplete extends TweetingState {}
