import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_tabs_bloc.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/tweet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTabLikes extends StatefulWidget {
  final UserProfileEntity userProfile;

  UserTabLikes({@required this.userProfile});
  @override
  _UserTabLikesState createState() => _UserTabLikesState();
}

class _UserTabLikesState extends State<UserTabLikes> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      context.read<ProfileTabBloc>().add(FetchUserLikes(userId: widget.userProfile.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileTabBloc, ProfileTabState>(
      buildWhen: (_, currentState) {
        return currentState is FetchingUserLikesComplete;
      },
      builder: (context, state) {
        if (state is FetchingUserLikes) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is FetchingUserLikesFailed) {
          return Center(child: Text(state.message));
        }
        if (state is FetchingUserLikesComplete) {
          return StreamBuilder<List<TweetEntity>>(
            stream: state.content,
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, index) => TweetItem(
                        key: ValueKey(snapshot.data[index].id),
                        tweet: snapshot.data[index],
                        profile: widget.userProfile,
                      ),
                    )
                  : Center(child: Text('No Likes'));
            },
          );
        }
        return Center(child: Text('Something went wrong'));
      },
    );
  }
}
