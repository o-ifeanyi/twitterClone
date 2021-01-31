import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter/cupertino.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    @required id,
    @required name,
    @required userName,
    token,
    bio,
    location,
    website,
    dateOfBirth,
    dateJoined,
    profilePhoto,
    coverPhoto,
    following,
    followers,
  }) : super(
          id: id,
          token: token,
          name: name,
          userName: userName,
          bio: bio,
          location: location,
          website: website,
          dateOfBirth: dateOfBirth,
          dateJoined: dateJoined,
          profilePhoto: profilePhoto,
          coverPhoto: coverPhoto,
          following: following,
          followers: followers,
        );

  factory UserProfileModel.fromDoc(DocumentSnapshot userDoc) {
    final data = userDoc.data();
    return UserProfileModel(
      id: userDoc.id,
      token: data['token'],
      name: data['name'],
      userName: data['userName'],
      bio: data['bio'] ?? '',
      location: data['location'] ?? '',
      website: data['website'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      dateJoined: data['dateJoined'],
      profilePhoto: data['profilePhoto'] ?? '',
      coverPhoto: data['coverPhoto'] ?? '',
      following: data['following'] ?? List<DocumentReference>(),
      followers: data['followers'] ?? List<DocumentReference>(),
    );
  }

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      id: entity.id,
      token: entity.token,
      name: entity.name,
      userName: entity.userName,
      bio: entity.bio,
      location: entity.location,
      website: entity.website,
      dateOfBirth: entity.dateOfBirth,
      dateJoined: entity.dateJoined,
      profilePhoto: entity.profilePhoto,
      coverPhoto: entity.coverPhoto,
      following: entity.following,
      followers: entity.followers,
    );
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: this.id,
      token: this.token,
      name: this.name,
      userName: this.userName,
      bio: this.bio,
      location: this.location,
      website: this.website,
      dateOfBirth: this.dateOfBirth,
      dateJoined: this.dateJoined,
      profilePhoto: this.profilePhoto,
      coverPhoto: this.coverPhoto,
      following: this.following,
      followers: this.followers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'token': this.token,
      'name': this.name,
      'userName': this.userName,
      'bio': this.bio,
      'location': this.location,
      'website': this.website,
      'dateOfBirth': this.dateOfBirth,
      'dateJoined': this.dateJoined,
      'profilePhoto': this.profilePhoto,
      'coverPhoto': this.coverPhoto,
      'following': this.following,
      'followers': this.followers,
    };
  }
}
