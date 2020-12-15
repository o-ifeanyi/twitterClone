import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeData theme;

  SettingsState({this.theme});
  @override
  List<Object> get props => [theme];
}


class AppTheme extends SettingsState {
  final ThemeData theme;

  AppTheme(this.theme) : super(theme: theme);
}