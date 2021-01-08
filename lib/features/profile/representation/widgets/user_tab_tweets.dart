import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_tabs_bloc.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/tweet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTabTweets extends StatefulWidget {
  final UserProfileEntity userProfile;

  UserTabTweets({@required this.userProfile});
  @override
  _UserTabTweetsState createState() => _UserTabTweetsState();
}

class _UserTabTweetsState extends State<UserTabTweets> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      context
          .read<ProfileTabBloc>()
          .add(FetchUserTweets(userId: widget.userProfile.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileTabBloc, ProfileTabState>(
      buildWhen: (_, currentState) {
        return currentState is FetchingUserTweetsComplete;
      },
      builder: (context, state) {
        if (state is FetchingUserTweets) {
          print('fetching');
          return Center(child: CircularProgressIndicator());
        }
        if (state is FetchingUserTweetsFailed) {
          return Center(child: Text(state.message));
        }
        if (state is FetchingUserTweetsComplete) {
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
                  : Center(child: Text('No Tweets'));
            },
          );
        }
        return Center(child: Text('Something went wrong'));
      },
    );
  }
}
