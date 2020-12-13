import 'package:fc_twitter/features/settings/data/repository/settings_repository.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  ThemeEntity themeEntity;
  MockSharedPreference sharedPreference;
  SettingsRepositoryImpl settingsRepositoryImpl;

  setUp(() {
    themeEntity = ThemeEntity(
      isLight: true,
      isDim: false,
      isLightsOut: true,
    );
    sharedPreference = MockSharedPreference();
    settingsRepositoryImpl =
        SettingsRepositoryImpl(sharedPreferences: sharedPreference);
  });

  group('settings repository', () {});
}
