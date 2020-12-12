
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/timeline/domain/entity/tweet_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class Params extends Equatable {
  final UserEntity user;
  final UserCredential credential;
  final TweetEntity tweet;

  Params({this.user, this.credential, this.tweet});

  @override
  List<Object> get props => [user, credential, tweet];
}