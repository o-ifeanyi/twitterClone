import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUp extends AuthEvent {
  final String email;
  final String password;
  final String username;

  SignUp({@required this.email, @required this.password, this.username});

  @override
  List<Object> get props => [email, password, username];
}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogOut extends AuthEvent {}

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

  AuthFailed(this.message);
  @override
  List<Object> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthState initialState) : super(initialState);
  final _auth = FirebaseAuth.instance;
  UserCredential _userCredential;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUp) {
      yield AuthInProgress();
      try {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userCredential.user.uid)
            .set({'username': event.username});
        yield AuthComplete();
      } on FirebaseAuthException catch (error) {
        print(error);
        yield AuthFailed('Auth exception => ${error.message}');
      } catch (error) {
        yield AuthFailed('$error');
      }
    }
    if (event is Login) {
      yield AuthInProgress();
      try {
        await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        yield AuthComplete();
      } on FirebaseAuthException catch (error) {
        print(error);
        yield AuthFailed('Auth exception => ${error.message}');
      } catch (error) {
        yield AuthFailed('$error');
      }
    }
    if (event is LogOut) {
      _auth.signOut();
    }
  }
}
