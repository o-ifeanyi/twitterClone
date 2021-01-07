
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  Future<Either<ProfileFailure, UserProfileEntity>> getUserProfile(String userId);

  Future<Either<ProfileFailure, File>> pickImage(ImageSource source, bool isCoverPhoto);

  Future<Either<ProfileFailure, UserProfileEntity>> uploadImage(UserProfileEntity userProfile);

  Future<Either<ProfileFailure, bool>> updateUserProfile(UserProfileEntity userProfile);

  Future<Either<ProfileFailure, bool>> follow(UserProfileEntity userProfile ,UserProfileEntity currentUser);

  Future<Either<ProfileFailure, bool>> unfollow(UserProfileEntity userProfile ,UserProfileEntity currentUser);

  Future<Either<ProfileFailure, StreamConverter>> fetchUserTweets(String userId);
}