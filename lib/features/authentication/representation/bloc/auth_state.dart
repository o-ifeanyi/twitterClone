import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthState extends Equatable {
  final bool isLoading;

  AuthState({this.isLoading = false});
  void showSnackBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
      String message,
      {bool isError = false}) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: isError
            ? Theme.of(context).errorColor
            : Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class AuthInProgress extends AuthState {
  AuthInProgress() : super(isLoading: true);
}

class AuthComplete extends AuthState {}

class AuthFailed extends AuthState {
  final String message;

  AuthFailed({this.message});
  @override
  List<Object> get props => [message];
}