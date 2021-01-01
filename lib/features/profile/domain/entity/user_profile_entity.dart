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
  final dynamic profilePhoto;
  final dynamic coverPhoto;
  final List following;
  final List followers;

  UserProfileEntity({
    this.id,
    this.name,
    this.userName,
    this.bio,
    this.location,
    this.website,
    this.dateOfBirth,
    this.dateJoined,
    this.profilePhoto,
    this.coverPhoto,
    this.following,
    this.followers,
  });
  @SemanticsHintOverrides()
  List<Object> get props => [id, name, userName];

  UserProfileEntity copyWith({
    String name,
    String bio,
    String location,
    String website,
    dynamic profilePhoto,
    dynamic coverPhoto,
    List following,
    List followers,
  }) {
    return UserProfileEntity(
      id: this.id,
      userName: this.userName,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      dateOfBirth: this.dateOfBirth,
      dateJoined: this.dateJoined,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
