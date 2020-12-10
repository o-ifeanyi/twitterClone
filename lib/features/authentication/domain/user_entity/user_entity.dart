import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UserEntity extends Equatable{
  final String name;
  final String userName;
  final String email;
  final String password;
  

  UserEntity({this.name, this.userName, @required  this.email, @required this.password,});

  @override
  List<Object> get props => [name, userName, email, password];
}