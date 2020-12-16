import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String name;
  final String userName;
  final String bio;
  final String location;
  final String website;
  final String dateOfBirth;
  final String dateJoined;
  final int following;
  final int followers;

  UserProfileEntity({
    this.id,
    this.name,
    this.userName,
    this.bio,
    this.location,
    this.website,
    this.dateOfBirth,
    this.dateJoined,
    this.following,
    this.followers,
  });
  @SemanticsHintOverrides()
  List<Object> get props => [id, name, userName];
}
