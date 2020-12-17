import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class AParams extends Equatable {
  final UserEntity user;
  final UserProfileModel userProfile;

  AParams({this.user, this.userProfile});

  @override
  List<Object> get props => [user, userProfile];
}

class TParams extends Equatable {
  final TweetEntity tweet;

  TParams({this.tweet});

  @override
  List<Object> get props => [tweet];
}

class PParams extends Equatable {
  final String userId;

  PParams({this.userId});

  @override
  List<Object> get props => [userId];
}

class SParams extends Equatable {
  final ThemeEntity themeEntity;

  SParams({this.themeEntity});

  @override
  List<Object> get props => [themeEntity];
}
