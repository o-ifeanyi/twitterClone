import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/authentication/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/profile/representation/widgets/theme_handler.dart';
import 'package:fc_twitter/features/settings/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/settings/representation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _customLightStyle = TextStyle(
      color: Theme.of(context).accentColor,
      fontSize: Config.xMargin(context, 4),
    );

    final List<Map<String, dynamic>> _drawerItems = [
      {'label': 'Profile', 'icon': Icons.person_outline_rounded},
      {'label': 'List', 'icon': Icons.list_alt_outlined},
      {'label': 'Topics', 'icon': MaterialCommunityIcons.comment_text_outline},
      {'label': 'Bookmarks', 'icon': Icons.bookmark_border_outlined},
      {'label': 'Moments', 'icon': Icons.bolt},
    ];
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ifeanyi',
                      style: TextStyle(
                          fontSize: Config.xMargin(context, 5),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '@onuoha_ifeanyi',
                      style: _customLightStyle,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '982',
                          style: TextStyle(
                              fontSize: Config.xMargin(context, 4),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' Followng',
                          style: _customLightStyle,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '1,180',
                          style: TextStyle(
                              fontSize: Config.xMargin(context, 4),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' Followers',
                          style: _customLightStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(
                thickness: 1,
                height: 0,
              ),
              Expanded(
                child: ListView(
                  children: [
                    ..._drawerItems.map(
                      (e) => ListTile(
                        leading: Icon(e['icon']),
                        title: Text(
                          e['label'],
                          style: TextStyle(
                            fontSize: Config.xMargin(context, 4.5),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(EvilIcons.external_link),
                      title: Text(
                        'Twitter Ads',
                        style: TextStyle(
                          fontSize: Config.xMargin(context, 4.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 10,
                    ),
                    ListTile(
                      title: Text(
                        'Settings and privacy',
                        style: TextStyle(
                          fontSize: Config.xMargin(context, 4.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () => context.read<AuthBloc>().add(LogOut()),
                      title: Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: Config.xMargin(context, 4.5),
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).errorColor
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      bool isDark = (state as AppTheme).theme.brightness == Brightness.dark;
                      return IconButton(
                        icon: Icon(
                          isDark
                              ? MaterialCommunityIcons.lightbulb_outline
                              : MaterialCommunityIcons.lightbulb_on_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: (context),
                            builder: (context) => ThemeHandler(),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.qrcode,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
