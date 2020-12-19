
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  Future<Either<ProfileFilure, UserProfileEntity>> getUserProfile(String userId);

  Future<Either<ProfileFilure, File>> pickImage(ImageSource source, bool isCoverPhoto);

  Future<Either<ProfileFilure, bool>> updateUserProfile(UserProfileEntity userProfile);
}