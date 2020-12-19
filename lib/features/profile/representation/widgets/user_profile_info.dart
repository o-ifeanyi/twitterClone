import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/profile/representation/pages/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _customGreyText = TextStyle(
      color: theme.accentColor,
      fontSize: Config.xMargin(context, 4),
    );
    final _customWhiteText = TextStyle(
      fontSize: Config.xMargin(context, 3.5),
    );
    return LayoutBuilder(builder: (context, constraints) {
      return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.userProfile == null) {
            return Container();
          }
          UserProfileEntity profile = state.userProfile;
          return Stack(
            children: [
              Container(
                height: constraints.maxHeight * 0.35,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: (profile.coverPhoto as String).isNotEmpty
                        ? NetworkImage(profile.coverPhoto)
                        : null,
                  ),
                ),
              ),
              Positioned(
                top: Config.yMargin(context, 13),
                child: Container(
                  height: constraints.maxHeight * 0.65,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: theme.accentColor,
                            backgroundImage:
                                (profile.profilePhoto as String).isNotEmpty
                                    ? NetworkImage(profile.profilePhoto)
                                    : null,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              EditProfileScreen.pageId,
                              arguments: profile,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.accentColor,
                                ),
                              ),
                              child: Text(
                                'Edit profile',
                                style: _customGreyText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        profile.name,
                        style: TextStyle(
                            fontSize: Config.xMargin(context, 5),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        profile.userName,
                        style: _customGreyText,
                      ),
                      if (profile.bio.isNotEmpty)
                        Text(profile.bio, style: _customWhiteText),
                      Wrap(
                        spacing: 15,
                        runSpacing: 5,
                        children: [
                          if (profile.location.isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  EvilIcons.location,
                                  size: 18,
                                  color: theme.accentColor,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  profile.location,
                                  style: _customGreyText,
                                ),
                              ],
                            ),
                          if (profile.website.isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  MaterialCommunityIcons.link_variant,
                                  size: 18,
                                  color: theme.accentColor,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  profile.website,
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: Config.xMargin(context, 3.5),
                                  ),
                                ),
                              ],
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MaterialCommunityIcons.calendar_month,
                                size: 16,
                                color: theme.accentColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                profile.dateJoined,
                                style: _customGreyText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${profile.following}',
                            style: TextStyle(
                                fontSize: Config.xMargin(context, 4),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' Followng',
                            style: _customGreyText,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${profile.followers}',
                            style: TextStyle(
                                fontSize: Config.xMargin(context, 4),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' Followers',
                            style: _customGreyText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
