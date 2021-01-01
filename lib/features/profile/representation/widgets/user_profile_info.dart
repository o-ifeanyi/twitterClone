import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:fc_twitter/features/profile/representation/pages/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'avatar.dart';

class UserProfileInfo extends StatelessWidget {
  final UserProfileEntity currentUser;
  final UserProfileEntity displayUser;
  final bool isCurrentUser;
  final bool isFollowing;

  UserProfileInfo(
      {@required this.currentUser,
      this.displayUser,
      this.isCurrentUser,
      this.isFollowing});
  @override
  Widget build(BuildContext context) {
    final user = displayUser ?? currentUser;
    final theme = Theme.of(context);
    final _customGreyText = TextStyle(
      color: theme.accentColor,
      fontSize: Config.xMargin(context, 4),
    );
    final _customWhiteText = TextStyle(
      fontSize: Config.xMargin(context, 3.5),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: constraints.maxHeight * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
              child: CachedNetworkImage(
                imageUrl: user.coverPhoto,
                placeholder: (_, __) => SizedBox.expand(),
                errorWidget: (_, __, ___) => SizedBox.expand(),
                fit: BoxFit.fitWidth,
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
                        Avatar(userProfile: user, radius: 30),
                        if (isCurrentUser)
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              EditProfileScreen.pageId,
                              arguments: user,
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
                        if (!isCurrentUser)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.scaffoldBackgroundColor,
                                  border: Border.all(color: theme.primaryColor),
                                ),
                                child: Icon(
                                  AntDesign.mail,
                                  size: 20,
                                  color: theme.primaryColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => context.read<ProfileBloc>().add(
                                      isFollowing
                                          ? UnFollow(
                                              userEntity: displayUser,
                                              currentUserEntity: currentUser,
                                            )
                                          : Follow(
                                              userEntity: displayUser,
                                              currentUserEntity: currentUser,
                                            ),
                                    ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isFollowing
                                        ? theme.primaryColor
                                        : theme.scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  child: Text(
                                    isFollowing ? 'Following' : 'Follow',
                                    style: TextStyle(
                                      fontSize: Config.xMargin(context, 4),
                                      color: isFollowing
                                          ? Colors.white
                                          : theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                          fontSize: Config.xMargin(context, 5),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.userName,
                      style: _customGreyText,
                    ),
                    if (user.bio.isNotEmpty)
                      Text(user.bio, style: _customWhiteText),
                    Wrap(
                      spacing: 15,
                      runSpacing: 5,
                      children: [
                        if (user.location.isNotEmpty)
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
                                user.location,
                                style: _customGreyText,
                              ),
                            ],
                          ),
                        if (user.website.isNotEmpty)
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
                                user.website,
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
                              user.dateJoined,
                              style: _customGreyText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${user.following.length}',
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
                          '${user.followers.length}',
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
  }
}
