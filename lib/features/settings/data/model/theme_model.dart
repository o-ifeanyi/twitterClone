import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:flutter/foundation.dart';

class ThemeModel extends ThemeEntity {
  ThemeModel({
    @required isLight,
    @required isDim,
    @required isLightsOut,
  }) : super(
          isLight: isLight,
          isDim: isDim,
          isLightsOut: isLightsOut,
        );

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      isLight: json['isLight'],
      isDim: json['isDim'],
      isLightsOut: json['isLightsOut'],
    );
  }

  factory ThemeModel.fromEntity(ThemeEntity theme) {
    return ThemeModel(
      isLight: theme.isLight,
      isDim: theme.isDim,
      isLightsOut: theme.isLightsOut,
    );
  }

  ThemeEntity toEntity() {
    return ThemeEntity(
      isLight: this.isLight,
      isDim: this.isDim,
      isLightsOut: this.isLightsOut,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLight': this.isLight,
      'isDim': this.isDim,
      'isLightsOut': this.isLightsOut,
    };
  }
}
