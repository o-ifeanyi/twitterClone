import 'package:fc_twitter/features/settings/representation/bloc/settings_state.dart';
import 'package:fc_twitter/features/settings/representation/bloc/settings_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({@required AppTheme appTheme}) : super(appTheme);

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async*{
    if (event is ChangeTheme) {
      yield AppTheme(event.theme);
    }
  }
  
} 