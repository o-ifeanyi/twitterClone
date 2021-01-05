import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/comment_bloc.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/representation/widgets/tweet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is FetchingComments) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor),
          );
        }
        if (state is FetchingCommentsComplete) {
          return StreamBuilder<List<TweetEntity>>(
            stream: state.commentStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: snapshot.data
                            .map(
                              (tweet) => FutureBuilder<DocumentSnapshot>(
                                  future: tweet.userProfile.get(),
                                  builder: (context, profileData) {
                                    if (profileData.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox.shrink();
                                    }
                                    final profile =
                                        UserProfileModel.fromDoc(profileData.data);
                                    return TweetItem(
                                      tweet: tweet,
                                      profile: profile,
                                    );
                                  }),
                            )
                            .toList(),
                      ),
                    )
                  : Center(child: Text('nothing'));
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
