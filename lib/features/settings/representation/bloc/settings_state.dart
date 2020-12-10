import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}


class AppTheme extends SettingsState {
  final ThemeData theme;

  AppTheme(this.theme);

   @override
  List<Object> get props => [theme];
}