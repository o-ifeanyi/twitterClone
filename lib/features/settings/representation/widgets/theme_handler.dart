import 'dart:convert';

import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/core/util/themes.dart';
import 'package:fc_twitter/features/settings/data/model/theme_model.dart';
import 'package:fc_twitter/features/settings/domain/entity/theme_entity.dart';
import 'package:fc_twitter/features/settings/representation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeHandler extends StatefulWidget {
  @override
  _ThemeHandlerState createState() => _ThemeHandlerState();
}

class _ThemeHandlerState extends State<ThemeHandler> {
  ThemeOptions _appTheme;
  DarkThemeOptions _darkAppTheme;
  ThemeEntity currentTheme;
  ThemeEntity themeEntity = ThemeEntity(
    isDim: false,
    isLight: false,
    isLightsOut: false,
  );

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      final theme = json.decode(pref.getString('theme') ??
          json.encode({'isLight': true, 'isDim': false, 'isLightsOut': true}));
      currentTheme = ThemeModel.fromJson(theme).toEntity();
      setState(() {
        themeEntity = currentTheme;
        _appTheme =
            currentTheme.isLight ? ThemeOptions.Light : ThemeOptions.Dark;
        _darkAppTheme = currentTheme.isDim
            ? DarkThemeOptions.Dim
            : DarkThemeOptions.LightsOut;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Config.yMargin(context, 45),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 40,
            child: Divider(thickness: 6, height: 25),
          ),
          Text(
            'Dark mode',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Config.xMargin(context, 4.5),
            ),
          ),
          RadioListTile<ThemeOptions>(
            title: Text('Off'),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: Theme.of(context).primaryColor,
            value: ThemeOptions.Light,
            groupValue: _appTheme,
            onChanged: (newTheme) {
              setState(() {
                _appTheme = newTheme;
              });
              themeEntity = ThemeEntity(
                isLight: true,
                isDim: themeEntity.isDim,
                isLightsOut: themeEntity.isLightsOut,
              );
              context.read<SettingsBloc>().add(ChangeTheme(themeEntity));
            },
          ),
          RadioListTile<ThemeOptions>(
            title: Text('On'),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: Theme.of(context).primaryColor,
            value: ThemeOptions.Dark,
            groupValue: _appTheme,
            onChanged: (newTheme) {
              setState(() {
                _appTheme = newTheme;
              });
              themeEntity = ThemeEntity(
                isLight: false,
                isDim: themeEntity.isDim,
                isLightsOut: themeEntity.isLightsOut,
              );
              context.read<SettingsBloc>().add(ChangeTheme(themeEntity));
            },
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
            child: Text('Dark theme'),
          ),
          RadioListTile<DarkThemeOptions>(
            title: Text('Dim'),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: Theme.of(context).primaryColor,
            value: DarkThemeOptions.Dim,
            groupValue: _darkAppTheme,
            onChanged: (newTheme) {
              setState(() {
                _darkAppTheme = newTheme;
              });
              themeEntity = ThemeEntity(
                isLight: themeEntity.isLight,
                isDim: true,
                isLightsOut: false,
              );
              context.read<SettingsBloc>().add(ChangeTheme(themeEntity));
            },
          ),
          RadioListTile<DarkThemeOptions>(
            title: Text('Lights out'),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: Theme.of(context).primaryColor,
            value: DarkThemeOptions.LightsOut,
            groupValue: _darkAppTheme,
            onChanged: (newTheme) {
              setState(() {
                _darkAppTheme = newTheme;
              });
              themeEntity = ThemeEntity(
                isLight: themeEntity.isLight,
                isDim: false,
                isLightsOut: true,
              );
              context.read<SettingsBloc>().add(ChangeTheme(themeEntity));
            },
          ),
        ],
      ),
    );
  }
}
