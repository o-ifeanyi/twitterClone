import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/settings/domain/usecase/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  ThemeEntity themeEntity;
  MockSettingsRepository settingsRepository;
  ChangeThemeUseCase changeThemeUseCase;

  setUp(() {
    themeEntity = ThemeEntity(
      isLight: true,
      isDim: false,
      isLightsOut: true,
    );
    settingsRepository = MockSettingsRepository();
    changeThemeUseCase =
        ChangeThemeUseCase(settingsRepository: settingsRepository);
  });

  group('changeTheme use case', () {
    test('should return a Theme entity when theme is changed', () async {
      when(settingsRepository.changeTheme(any)).thenAnswer(
        (_) => Future.value(Right(themeEntity)),
      );

      final result = await changeThemeUseCase(SParams(themeEntity: themeEntity));

      expect(result, Right(themeEntity));
      verify(settingsRepository.changeTheme(any));
    });

    test('should return a SettingsFailure when error occurs', () async {
      when(settingsRepository.changeTheme(any)).thenAnswer(
        (_) => Future.value(Left(SettingsFailure())),
      );

      final result = await changeThemeUseCase(SParams(themeEntity: themeEntity));

      expect(result, Left(SettingsFailure()));
      verify(settingsRepository.changeTheme(any));
    });
  });
}
