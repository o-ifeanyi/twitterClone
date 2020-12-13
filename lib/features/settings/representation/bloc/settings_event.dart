import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';

class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];

}

class ChangeTheme extends SettingsEvent {
  final ThemeEntity theme;

  ChangeTheme(this.theme);

  @override
  List<Object> get props => [theme];
}