import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ProfileRepositoryImpl({this.firebaseFirestore, this.firebaseStorage});
  @override
  Future<Either<ProfileFailure, UserProfileEntity>> getUserProfile(
      String userId) async {
    try {
      final userProfile =
          await firebaseFirestore.collection('users').doc(userId).get();
      return Right(UserProfileModel.fromDoc(userProfile).toEntity());
    } catch (_) {
      return Left(ProfileFailure());
    }
  }

  @override
  Future<Either<ProfileFailure, bool>> updateUserProfile(
      UserProfileEntity userProfile) async {
    try {
      final data = UserProfileModel.fromEntity(userProfile).toMap();
      await firebaseFirestore.collection('users').doc(userProfile.id).set(data);
      return Right(true);
    } catch (_) {
      return Left(ProfileFailure());
    }
  }

  @override
  Future<Either<ProfileFailure, File>> pickImage(
      ImageSource source, bool isCoverPhoto) async {
    final pickedFile = await ImagePicker().getImage(
      source: source,
      imageQuality: isCoverPhoto ? null : 50,
      maxWidth: isCoverPhoto ? null : 150,
    );
    if (pickedFile == null) {
      return Left(ProfileFailure());
    }
    return Right(File(pickedFile.path));
  }

  @override
  Future<Either<ProfileFailure, UserProfileEntity>> uploadImage(
      UserProfileEntity userProfile) async {
    try {
      if (userProfile.profilePhoto.runtimeType != String) {
        print('uploading');
        final ref =
            firebaseStorage.ref().child(userProfile.id).child('profile.jpg');
        await ref.putFile(userProfile.profilePhoto).whenComplete(() async {
          final imageUrl = await ref.getDownloadURL();
          userProfile = userProfile.copyWith(profilePhoto: imageUrl);
          print('image url gotten => ${userProfile.profilePhoto}');
        });
      }
      if (userProfile.coverPhoto.runtimeType != String) {
        print('uploading');
        final ref =
            firebaseStorage.ref().child(userProfile.id).child('cover.jpg');
        await ref.putFile(userProfile.coverPhoto).whenComplete(() async {
          final imageUrl = await ref.getDownloadURL();
          userProfile = userProfile.copyWith(coverPhoto: imageUrl);
          print('image url gotten => ${userProfile.coverPhoto}');
        });
      }
      return Right(userProfile);
    } catch (_) {
      return Left(ProfileFailure());
    }
  }

  @override
  Future<Either<ProfileFailure, bool>> follow(
    UserProfileEntity userProfile,
    UserProfileEntity currentUser,
  ) async {
    try {
      final userCollection = firebaseFirestore.collection('users');
      final followers = userProfile.followers;
      followers?.add(firebaseFirestore.collection('users').doc(currentUser.id));
      await userCollection.doc(userProfile.id).update({'followers': followers});
      final following = currentUser.following;
      following?.add(firebaseFirestore.collection('users').doc(userProfile.id));
      await userCollection.doc(currentUser.id).update({'following': following});
      return Right(true);
    } catch (error) {
      print(error);
      return Left(ProfileFailure());
    }
  }

  @override
  Future<Either<ProfileFailure, bool>> unfollow(
    UserProfileEntity userProfile,
    UserProfileEntity currentUser,
  ) async {
    final userCollection = firebaseFirestore.collection('users');
    try {
      final followers = userProfile.followers;
      followers?.removeWhere((element) => element.path.endsWith(currentUser.id));
      await userCollection.doc(userProfile.id).update({'followers': followers});
      final following = currentUser.following;
      following?.removeWhere((element) => element.path.endsWith(userProfile.id));
      await userCollection.doc(currentUser.id).update({'following': following});
      return Right(true);
    } catch (error) {
      print(error);
      return Left(ProfileFailure());
    }
  }
}
