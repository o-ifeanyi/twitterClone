import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/settings/data/model/theme_model.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/settings/domain/repository/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences sharedPreferences;

  SettingsRepositoryImpl({this.sharedPreferences});

  @override
  Future<Either<SettingsFailure, ThemeEntity>> changeTheme(
      ThemeEntity theme) async {
    try {
      final themeMap = json.encode(ThemeModel.fromEntity(theme).toJson());
      await sharedPreferences.setString('theme', themeMap);
      return Right(theme);
    } catch (_) {
      return Left(SettingsFailure());
    }
  }
}
