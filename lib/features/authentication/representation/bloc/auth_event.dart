import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';

class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUp extends AuthEvent {
  final UserEntity user;

  SignUp({this.user});

  @override
  List<Object> get props => [user];
}

class Login extends AuthEvent {
  final UserEntity user;

  Login({this.user});

  @override
  List<Object> get props => [user];
}

class LogOut extends AuthEvent {}