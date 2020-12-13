
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';

abstract class SettingsRepository {
  Future<Either<SettingsFailure, ThemeEntity>> changeTheme(ThemeEntity theme);
}