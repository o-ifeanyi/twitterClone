import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/domain/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  UserRepositoryImpl({this.firebaseAuth, this.firebaseFirestore})
      : assert(firebaseAuth != null),
        assert(firebaseFirestore != null);

  @override
  Future<Either<AuthFailure, UserCredential>> logInUser(UserModel user) async {
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
  void logOutUser() {
    firebaseAuth.signOut();
  }

  @override
  Future<Either<AuthFailure, UserCredential>> signUpNewUser(
      UserModel user) async {
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
      UserCredential credential) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(credential.user.uid)
          .set({'username': credential.user.displayName});
      return Right(true);
    } catch (error) {
      return Left(AuthFailure(message: 'Saving failed'));
    }
  }
}
