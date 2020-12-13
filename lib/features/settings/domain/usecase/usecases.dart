
import 'package:fc_twitter/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/settings/domain/repository/settings_repository.dart';

class ChangeThemeUseCase implements UseCase<ThemeEntity, SParams> {
  final SettingsRepository settingsRepository;

  ChangeThemeUseCase({this.settingsRepository});
  @override
  Future<Either<SettingsFailure, ThemeEntity>> call(SParams params) async{
    return await settingsRepository.changeTheme(params.themeEntity);
  }
}