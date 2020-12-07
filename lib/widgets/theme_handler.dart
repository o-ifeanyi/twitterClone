import 'package:fc_twitter/bloc/theme_bloc.dart';
import 'package:fc_twitter/util/config.dart';
import 'package:fc_twitter/util/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOptions {
  Light,
  Dark,
}

enum DarkThemeOptions {
  Dim,
  LightsOut,
}

class ThemeHandler extends StatefulWidget {
  @override
  _ThemeHandlerState createState() => _ThemeHandlerState();
}

class _ThemeHandlerState extends State<ThemeHandler> {
  int _themeIndex;
  int _darkThemeIndex;
  ThemeOptions _appTheme;
  DarkThemeOptions _darkAppTheme;

  void _saveTheme(ThemeOptions option) {
    SharedPreferences.getInstance().then((pref) {
      pref.setInt('theme', option.index);
    });
  }

  void _saveDarkTheme(DarkThemeOptions option) {
    SharedPreferences.getInstance().then((pref) {
      pref.setInt('darktheme', option.index);
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        _themeIndex = pref.getInt('theme') ?? 0;
        _darkThemeIndex = pref.getInt('darktheme') ?? 0;
        _appTheme = _themeIndex == 0 ? ThemeOptions.Light : ThemeOptions.Dark;
        _darkAppTheme = _darkThemeIndex == 0
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
            child: Divider(
              thickness: 6,
              height: 25,
            ),
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
                _themeIndex = ThemeOptions.Light.index;
              });
              context.read<ThemeBloc>().add(ChangeTheme(lightThemeData[_themeIndex]));
              _saveTheme(newTheme);
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
                _themeIndex = ThemeOptions.Dark.index;
              });
              context.read<ThemeBloc>().add(ChangeTheme(darkThemeData[_darkThemeIndex]));
              _saveTheme(newTheme);
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
              if (_themeIndex == 0) {
                _darkThemeIndex = 0;
              } else {
                context.read<ThemeBloc>().add(ChangeTheme(darkThemeData[newTheme.index]));
              }
              _saveDarkTheme(newTheme);
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
              if (_themeIndex == 0) {
                _darkThemeIndex = 1;
              } else {
                context.read<ThemeBloc>().add(ChangeTheme(darkThemeData[newTheme.index]));
              }
              _saveDarkTheme(newTheme);
            },
          ),
        ],
      ),
    );
  }
}
