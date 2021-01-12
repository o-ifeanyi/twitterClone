import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:flutter/cupertino.dart';

class UserModel extends UserEntity {
  UserModel({
    name,
    userName,
    @required email,
    @required password,
  }) : super(
          name: name,
          userName: userName,
          email: email,
          password: password,
        );

  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      email: userEntity.email,
      password: userEntity.password,
      userName: userEntity.userName,
      name: userEntity.name,
    );
  }
}
