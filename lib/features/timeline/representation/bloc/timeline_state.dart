import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:flutter/material.dart';

class TimeLineState extends Equatable {
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

class InitialTimeLineState extends TimeLineState {}

class FetchingTweet extends TimeLineState {}

class FetchingError extends TimeLineState {
  final String message;

  FetchingError({this.message});

  @override
  List<Object> get props => [message];
}

class FetchingComplete extends TimeLineState {
  final Stream<List<TweetEntity>> tweetStream;

  FetchingComplete({this.tweetStream});
}