import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/domain/repository/user_repository.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseMessaging firebaseMessaging;
  final FirebaseFirestore firebaseFirestore;

  UserRepositoryImpl({this.firebaseAuth, this.firebaseFirestore, this.firebaseMessaging})
      : assert(firebaseAuth != null),
        assert(firebaseFirestore != null);

  @override
  Future<Either<AuthFailure, UserCredential>> logInUser(UserEntity user) async {
    UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      return Right(userCredential);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure(message: error.message));
    } catch (error) {
      return Left(AuthFailure(message: 'Login failed'));
    }
  }

  @override
  Future<Either<AuthFailure, bool>> logOutUser() async{
    await firebaseAuth.signOut();
    return Right(true);
  }

  @override
  Future<Either<AuthFailure, UserCredential>> signUpNewUser(
      UserEntity user) async {
    UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      return Right(userCredential);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure(message: error.message));
    } catch (error) {
      return Left(AuthFailure(message: 'Sign up failed'));
    }
  }

  @override
  Future<Either<AuthFailure, bool>> saveUserDetail(
      UserProfileEntity userProfile) async {
    try {
      final userDetail = userProfile.copyWith(token: await firebaseMessaging.getToken());
      await firebaseFirestore
          .collection('users')
          .doc(userDetail.id)
          .set(UserProfileModel.fromEntity(userDetail).toMap());
      return Right(true);
    } catch (error) {
      return Left(AuthFailure(message: 'Saving failed'));
    }
  }
}
