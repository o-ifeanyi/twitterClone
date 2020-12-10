import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/representation/widgets/tweet_item.dart';
import 'package:flutter/material.dart';
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tweets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomScrollView(slivers: [
              appBar,
              SliverFillRemaining(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ]);
          }
          final List<QueryDocumentSnapshot> tweets = snapshot.data.docs;
          return tweets.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    appBar,
                    SliverFillRemaining(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: tweets.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(thickness: 1, height: 15),
                        itemBuilder: (ctx, index) => TweetItem(
                          TweetModel.fromSnapShot(tweets[index]),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text('Nothing yet'),
                );
        });
  }
}
