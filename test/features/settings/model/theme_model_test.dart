import 'package:fc_twitter/features/settings/data/model/theme_model.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  ThemeModel themeModel;
  ThemeEntity themeEntity;
  Map<String, dynamic> json;

  setUp(() {
    themeModel = themeModelFixture();
    themeEntity = themeEntityFixture();
    json = themeJsonFixture();
  });

  group('theme model', () {
    test('should return a valid model from json file', () {

      final result = ThemeModel.fromJson(json);

      expect(result, themeModel);
    });

    test('should return a valid model from entity', () {
      final result = ThemeModel.fromEntity(themeEntity);

      expect(result, themeModel);
    });

    test('should return a valid entity from model', () {
      final result = themeModel.toEntity();

      expect(result, themeEntity);
    });

    test('should return a valid json from model', () {
      final result = themeModel.toJson();

      expect(result, json);
    });
  });
}
