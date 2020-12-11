import 'package:fc_twitter/features/timeline/data/model/tweet_model.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/timeline/representation/widgets/tweet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
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
      ),
      body: BlocBuilder<TimeLineBloc, TimeLineState>(
        buildWhen: (prevState, currentState) {
          return currentState is FetchingComplete;
          // sending tweet changes the state making it return a loading indicator
        },
        builder: (context, state) {
          return state is FetchingComplete
              ? StreamBuilder<List<TweetModel>>(
                  stream: state.tweetStream,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.separated(
                            padding: const EdgeInsets.all(10),
                            itemCount: snapshot.data.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    Divider(thickness: 1, height: 15),
                            itemBuilder: (ctx, index) =>
                                TweetItem(snapshot.data[index]),
                          )
                        : Center(child: Text('Nothing to show'));
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
