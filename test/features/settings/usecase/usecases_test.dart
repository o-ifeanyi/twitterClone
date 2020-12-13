import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/settings/domain/repository/settings_repository.dart';
import 'package:fc_twitter/features/settings/domain/usecase/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

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

  group('use case', () {
    test('should return a Theme entity when theme is changed', () async {
      when(settingsRepository.changeTheme(any)).thenAnswer(
        (_) => Future.value(Right(themeEntity)),
      );

      final result = await changeThemeUseCase(SParams(themeEntity: themeEntity));

      expect(result, Right(themeEntity));
      verify(settingsRepository.changeTheme(any));
    });
  });
}
