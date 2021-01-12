import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({Key key, this.userProfile, this.currentUser})
      : super(key: key);

  final UserProfileEntity userProfile;
  final UserProfileEntity currentUser;

  GestureDetector _button(
      {BuildContext context, Function onPressed, String label, Icon icon}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser = userProfile?.id == currentUser?.id;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            alignment: Alignment.centerLeft,
            height: Config.yMargin(context, isCurrentUser ? 14 : 30),
            child: isCurrentUser
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _button(
                        context: context,
                        onPressed: () {
                          print('pin to profile');
                        },
                        label: 'Pin from profile',
                        icon: Icon(MaterialCommunityIcons.pin_outline,
                            color: theme.accentColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: _button(
                          context: context,
                          onPressed: () {
                            print('delete tweet');
                          },
                          label: 'Delete Tweet',
                          icon: Icon(AntDesign.delete,
                              size: 18, color: theme.accentColor),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _button(
                        context: context,
                        onPressed: () {
                          print('Unfollow ${userProfile.userName}');
                        },
                        label: 'Unfollow ${userProfile.userName}',
                        icon: Icon(AntDesign.deleteuser,
                            color: theme.accentColor),
                      ),
                      _button(
                        context: context,
                        onPressed: () {
                          print('Add/remove from Lists');
                        },
                        label: 'Add/remove from Lists',
                        icon: Icon(Icons.list_alt_outlined,
                            color: theme.accentColor),
                      ),
                      _button(
                        context: context,
                        onPressed: () {
                          print('Mute ${userProfile.userName}');
                        },
                        label: 'Mute ${userProfile.userName}',
                        icon: Icon(SimpleLineIcons.volume_off,
                            color: theme.accentColor),
                      ),
                      _button(
                        context: context,
                        onPressed: () {
                          print('Block ${userProfile.userName}');
                        },
                        label: 'Block ${userProfile.userName}',
                        icon: Icon(Icons.block_outlined,
                            color: theme.accentColor),
                      ),
                      _button(
                        context: context,
                        onPressed: () {
                          print('Report Tweet');
                        },
                        label: 'Report Tweet',
                        icon: Icon(MaterialCommunityIcons.flag_variant_outline,
                            color: theme.accentColor),
                      ),
                    ],
                  ),
          ),
        );
      },
      child: Icon(
        Icons.expand_more_outlined,
        color: theme.accentColor,
      ),
    );
  }
}