import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/representation/widgets/user_profile_info.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String pageId = '/profileScreen';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: SafeArea(
                  child: CustomScrollView(
            slivers: [
              SliverAppBar(
                stretch: true,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                expandedHeight: Config.yMargin(context, 50),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: UserProfileInfo(),
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: theme.primaryColor,
                  labelPadding: const EdgeInsets.only(bottom: 10),
                  labelColor: theme.primaryColor,
                  unselectedLabelColor: theme.accentColor,
                  tabs: [
                    Text('Tweets'),
                    Text('Replies'),
                    Text('Media'),
                    Text('Likes'),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text('one'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text('two'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text('three'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text('four'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
