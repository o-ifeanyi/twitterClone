import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/pages/edit_profile_screen.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserProfileInfo extends StatelessWidget {
  final UserProfileEntity profileEntity;

  UserProfileInfo({@required this.profileEntity});
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
      return Stack(
            children: [
              Container(
                height: constraints.maxHeight * 0.35,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                ),
                child: CachedNetworkImage(
                  imageUrl: profileEntity.coverPhoto,
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
                          Avatar(imageUrl: profileEntity.profilePhoto, radius: 30),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              EditProfileScreen.pageId,
                              arguments: profileEntity,
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
                        profileEntity.name,
                        style: TextStyle(
                            fontSize: Config.xMargin(context, 5),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        profileEntity.userName,
                        style: _customGreyText,
                      ),
                      if (profileEntity.bio.isNotEmpty)
                        Text(profileEntity.bio, style: _customWhiteText),
                      Wrap(
                        spacing: 15,
                        runSpacing: 5,
                        children: [
                          if (profileEntity.location.isNotEmpty)
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
                                  profileEntity.location,
                                  style: _customGreyText,
                                ),
                              ],
                            ),
                          if (profileEntity.website.isNotEmpty)
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
                                  profileEntity.website,
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
                                profileEntity.dateJoined,
                                style: _customGreyText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${profileEntity.following}',
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
                            '${profileEntity.followers}',
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
