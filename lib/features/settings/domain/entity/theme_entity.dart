import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ThemeEntity extends Equatable {
  final bool isLight;
  final bool isDim;
  final bool isLightsOut;

  ThemeEntity({
   @required this.isLight,
   @required this.isDim,
   @required this.isLightsOut,
  });

  @override
  List<Object> get props =>
      [isLight, isDim, isLightsOut];
}
