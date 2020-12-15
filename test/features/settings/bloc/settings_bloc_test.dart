import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/core/util/themes.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/settings/representation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  MockChangeTheme changeTheme;
  SettingsBloc settingsBloc;
  ThemeEntity themeEntity;

  setUp(() {
    changeTheme = MockChangeTheme();
    settingsBloc = SettingsBloc(
      appTheme: AppTheme(ThemeData()),
      changeTheme: changeTheme,
    );
  });

  group('change theme', () {
    test('should emit AppTheme with light theme option', () {
      themeEntity = ThemeEntity(isLight: true, isDim: false, isLightsOut: true);
      when(changeTheme(SParams(themeEntity: themeEntity))).thenAnswer(
        (_) => Future.value(Right(themeEntity)),
      );

      final expected = [AppTheme(themeOptions[ThemeOptions.Light])];

      expectLater(settingsBloc, emitsInOrder(expected));
      settingsBloc.add(ChangeTheme(themeEntity));
    });

    test('should emit AppTheme with dim theme option', () {
      themeEntity = ThemeEntity(isLight: false, isDim: true, isLightsOut: false);
      when(changeTheme(SParams(themeEntity: themeEntity))).thenAnswer(
        (_) => Future.value(Right(themeEntity)),
      );

      final expected = [AppTheme(themeOptions[DarkThemeOptions.Dim])];

      expectLater(settingsBloc, emitsInOrder(expected));
      settingsBloc.add(ChangeTheme(themeEntity));
    });

    test('should emit AppTheme with lightsOut theme option', () {
      themeEntity = ThemeEntity(isLight: false, isDim: false, isLightsOut: true);
      when(changeTheme(SParams(themeEntity: themeEntity))).thenAnswer(
        (_) => Future.value(Right(themeEntity)),
      );

      final expected = [AppTheme(themeOptions[DarkThemeOptions.LightsOut])];

      expectLater(settingsBloc, emitsInOrder(expected));
      settingsBloc.add(ChangeTheme(themeEntity));
    });
  });
}
