
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore firebaseFirestore;

  ProfileRepositoryImpl({this.firebaseFirestore});
  @override
  Future<Either<ProfileFilure, UserProfileEntity>> getUserProfile(String userId) async{
    try{
      final userProfile = await firebaseFirestore.collection('users').doc(userId).get();
      return Right(UserProfileModel.fromDoc(userProfile).toEntity());
    } catch (_) {
      return Left(ProfileFilure());
    }
  }

  @override
  Future<Either<ProfileFilure, bool>> updateUserProfile(UserProfileEntity userProfile) async{
    try{
      final data = UserProfileModel.fromEntity(userProfile).toMap();
      await firebaseFirestore.collection('users').doc(userProfile.id).set(data);
      return Right(true);
    } catch (_) {
      return Left(ProfileFilure());
    }
  }

}