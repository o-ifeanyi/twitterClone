import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/timeline/representation/widgets/tweet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1,
      snap: true,
      floating: true,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
      title: IconButton(
          icon: Icon(
            FontAwesome.twitter,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {}),
      actions: [
        IconButton(
          icon: Icon(
            Icons.star_border_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
    );
    return BlocBuilder<TimeLineBloc, TimeLineState>(
      buildWhen: (prevState, currentState) {
        return currentState is FetchingComplete;
      },
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            appBar,
            SliverFillRemaining(
              child: state is FetchingComplete
                  ? StreamBuilder<QuerySnapshot>(
                      stream: state.tweetStream,
                      builder: (context, snapshot) {
                        final List<QueryDocumentSnapshot> tweets =
                            snapshot.hasData ? snapshot.data.docs : [];
                        return tweets.isNotEmpty
                            ? ListView.separated(
                                padding: const EdgeInsets.all(10),
                                itemCount: tweets.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(thickness: 1, height: 15),
                                itemBuilder: (ctx, index) => TweetItem(
                                  TweetModel.fromSnapShot(tweets[index]),
                                ),
                              )
                            : Center(child: CircularProgressIndicator());
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      },
    );
  }
}
