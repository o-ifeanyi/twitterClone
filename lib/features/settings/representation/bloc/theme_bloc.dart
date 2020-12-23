import 'package:equatable/equatable.dart';
import 'package:fc_twitter/core/util/themes.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];

}

class ChangeTheme extends ThemeEvent {
  final ThemeEntity theme;

  ChangeTheme(this.theme);

  @override
  List<Object> get props => [theme];
}
class ThemeState extends Equatable {
  final ThemeData theme;

  ThemeState({this.theme});
  @override
  List<Object> get props => [theme];
}

class AppTheme extends ThemeState {
  final ThemeData newTheme;

  AppTheme(this.newTheme) : super(theme: newTheme);
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SettingsRepository settingsRepository;
  ThemeBloc({
    @required AppTheme appTheme,
    this.settingsRepository,
  }) : super(appTheme);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ChangeTheme) {
      final changeEither = await settingsRepository.changeTheme(event.theme);
      yield* changeEither.fold((falure) => throw UnimplementedError(),
          (theme) async* {
        if (theme.isLight) {
          yield AppTheme(themeOptions[ThemeOptions.Light]);
        } else if (theme.isDim) {
          yield AppTheme(themeOptions[DarkThemeOptions.Dim]);
        } else
          yield AppTheme(themeOptions[DarkThemeOptions.LightsOut]);
      });
    }
  }
}
