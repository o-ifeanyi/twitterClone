import 'package:fc_twitter/features/notification/representation/widgets/all_notifications.dart';
import 'package:fc_twitter/features/notification/representation/widgets/mentions.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = context.select<ProfileBloc, UserProfileEntity>(
      (bloc) => bloc.state.userProfile,
    );
    return DefaultTabController(
      length: 2,
          child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 1,
            leading: IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Foundation.list, color: theme.primaryColor),
            ),
            title: Text('Notifications', style: theme.textTheme.headline6),
            actions: [
              IconButton(
                  icon: Icon(
                    AntDesign.setting,
                    color: theme.primaryColor,
                  ),
                  onPressed: () {}),
            ],
            bottom: TabBar(
              indicatorColor: theme.primaryColor,
              labelPadding: const EdgeInsets.only(bottom: 10),
              labelColor: theme.primaryColor,
              unselectedLabelColor: theme.accentColor,
              tabs: [
                Text('All'),
                Text('Mentions'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AllNotifications(),
              Mentions(),
            ],
          )),
    );
  }
}
