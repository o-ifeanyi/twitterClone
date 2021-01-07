import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_tabs_bloc.dart';
import 'package:fc_twitter/features/profile/representation/widgets/user_profile_info.dart';
import 'package:fc_twitter/features/profile/representation/widgets/user_tab_likes.dart';
import 'package:fc_twitter/features/profile/representation/widgets/user_tab_media.dart';
import 'package:fc_twitter/features/profile/representation/widgets/user_tab_replies.dart';
import 'package:fc_twitter/features/profile/representation/widgets/user_tab_tweets.dart';
import 'package:fc_twitter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String pageId = '/profileScreen';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final UserProfileEntity userProfile =
        ModalRoute.of(context).settings.arguments;
    final profile = context.select<ProfileBloc, UserProfileEntity>(
      (bloc) => bloc.state.userProfile,
    );
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
                    child: UserProfileInfo(
                      currentUser: profile,
                      displayUser: userProfile,
                      isCurrentUser: userProfile != null
                          ? userProfile.id == profile.id
                          : true,
                      isFollowing: userProfile != null
                          ? profile.following.any((element) =>
                              (element as DocumentReference)
                                  .path
                                  .endsWith(userProfile.id))
                          : false,
                    ),
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
                child: BlocProvider<ProfileTabBloc>(
                  create: (context) => sl<ProfileTabBloc>(),
                  child: TabBarView(
                    children: [
                      UserTabTweets(userId: userProfile != null
                          ? userProfile.id : profile.id),
                      UserTabReplies(userId: userProfile != null
                          ? userProfile.id : profile.id),
                      UserTabMedias(userId: userProfile != null
                          ? userProfile.id : profile.id),
                      UserTabLikes(userId: userProfile != null
                          ? userProfile.id : profile.id),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
