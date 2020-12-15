import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class AParams extends Equatable {
  final UserEntity user;
  final UserCredential credential;

  AParams({this.user, this.credential});

  @override
  List<Object> get props => [user, credential];
}

class TParams extends Equatable {
  final TweetEntity tweet;

  TParams({this.tweet});

  @override
  List<Object> get props => [tweet];
}

class SParams extends Equatable {
  final ThemeEntity themeEntity;

  SParams({this.themeEntity});

  @override
  List<Object> get props => [themeEntity];
}
