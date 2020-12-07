import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/models/tweet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TweetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendTweet extends TweetEvent {
  final TweetModel tweet;

  SendTweet(this.tweet);

  @override
  List<Object> get props => [tweet];
}

class TweetState extends Equatable {
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

class InitialState extends TweetState {}

class SendingTweet extends TweetState {}

class SendingError extends TweetState {}

class SendingComplete extends TweetState {}

class TweetBloc extends Bloc<TweetEvent, TweetState> {
  TweetBloc(TweetState initialState) : super(initialState);

  @override
  Stream<TweetState> mapEventToState(TweetEvent event) async* {
    if (event is SendTweet) {
      yield SendingTweet();
      try {
        // send tweet
        await FirebaseFirestore.instance.collection('tweets').add({
          'name': event.tweet.name,
          'userName': event.tweet.userName,
          'message': event.tweet.message,
          'timeStamp': event.tweet.timestamp,
        });
        yield SendingComplete();
      } catch (e) {
        print(e);
        yield SendingError();
      }
    }
  }
}
