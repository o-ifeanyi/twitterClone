import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];

}

class ChangeTheme extends SettingsEvent {
  final ThemeData theme;

  ChangeTheme(this.theme);

  @override
  List<Object> get props => [theme];
}