import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter/cupertino.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    @required id,
    @required name,
    @required userName,
    bio,
    location,
    website,
    dateOfBirth,
    dateJoined,
    following,
    followers,
  }) : super(
          id: id,
          name: name,
          userName: userName,
          bio: bio,
          location: location,
          website: website,
          dateOfBirth: dateOfBirth,
          dateJoined: dateJoined,
          following: following,
          followers: followers,
        );

  factory UserProfileModel.fromDoc(DocumentSnapshot userDoc) {
    final data = userDoc.data();
    return UserProfileModel(
      id: userDoc.id,
      name: data['name'],
      userName: data['userName'],
      bio: data['bio'],
      location: data['location'],
      website: data['website'],
      dateOfBirth: data['dateOfBirth'],
      dateJoined: data['dateJoined'],
      following: data['following'],
      followers: data['followers'],
    );
  }

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      userName: entity.userName,
      bio: entity.bio,
      location: entity.location,
      website: entity.website,
      dateOfBirth: entity.dateOfBirth,
      dateJoined: entity.dateJoined,
      following: entity.following,
      followers: entity.followers,
    );
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: this.id,
      name: this.name,
      userName: this.userName,
      bio: this.bio,
      location: this.location,
      website: this.website,
      dateOfBirth: this.dateOfBirth,
      dateJoined: this.dateJoined,
      following: this.following,
      followers: this.followers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'userName': this.userName,
      'bio': this.bio,
      'location': this.location,
      'website': this.website,
      'dateOfBirth': this.dateOfBirth,
      'dateJoined': this.dateJoined,
      'following': this.following,
      'followers': this.followers,
    };
  }
}
