import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/core/util/themes.dart';
import 'package:fc_twitter/features/settings/domain/usecase/usecases.dart';
import 'package:fc_twitter/features/settings/representation/bloc/settings_state.dart';
import 'package:fc_twitter/features/settings/representation/bloc/settings_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ChangeThemeUseCase changeTheme;
  SettingsBloc({@required AppTheme appTheme, this.changeTheme})
      : super(appTheme);

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ChangeTheme) {
      final changeEither = await changeTheme(SParams(themeEntity: event.theme));
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
