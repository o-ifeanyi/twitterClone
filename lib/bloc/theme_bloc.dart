
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];

}

class ChangeTheme extends ThemeEvent {
  final ThemeData theme;

  ChangeTheme(this.theme);

  @override
  List<Object> get props => [theme];
}

class ThemeState extends Equatable {
  final ThemeData theme;

  ThemeState(this.theme);

  @override
  List<Object> get props => [theme];
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(ThemeState initialState) : super(initialState);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async*{
    if (event is ChangeTheme) {
      yield ThemeState(event.theme);
    }
  }
  
} 