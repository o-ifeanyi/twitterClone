import 'package:fc_twitter/bloc/tweet_bloc.dart';
import 'package:fc_twitter/screens/home_screen.dart';
import 'package:fc_twitter/screens/message_screen.dart';
import 'package:fc_twitter/screens/notification_screen.dart';
import 'package:fc_twitter/screens/search_screen.dart';
import 'package:fc_twitter/widgets//icons/new_message_icon.dart';
import 'package:fc_twitter/widgets//icons/new_tweet_icon.dart';
import 'package:fc_twitter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationScreen extends StatefulWidget {
  static const String pageId = '/navigation';
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BottomNavigationBarItem _barItem(IconData inactiveIcon, IconData activeIcon) {
    return BottomNavigationBarItem(
      label: '',
      activeIcon: Icon(
        activeIcon,
        color: Theme.of(context).primaryColor,
      ),
      icon: Icon(
        inactiveIcon,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget _getActionButton(int index) {
    switch (index) {
      case 0:
      case 1:
      case 2:
        return NewTweetIcon();
        break;
      case 3:
        return NewMessageIcon();
        break;
      default:
        return null;
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(),
      SearchScreen(),
      NotificationScreen(),
      MessageScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: SafeArea(
        child: BlocListener<TweetBloc, TweetState>(
          listener: (context, state) {
            if (state is SendingTweet) {
              state.showSnackBar(context, _scaffoldKey, 'Sending', 20);
            } else if (state is SendingError) {
              state.showSnackBar(context, _scaffoldKey, 'Error', 2,
                  isError: true);
            } else if (state is SendingComplete) {
              state.showSnackBar(context, _scaffoldKey, 'Complete', 2);
            }
          },
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        items: [
          _barItem(Icons.home_outlined, Icons.home),
          _barItem(Icons.search_outlined, Icons.search),
          _barItem(Icons.notifications_none_outlined, Icons.notifications),
          _barItem(Icons.mail_outline_rounded, Icons.mail_rounded),
        ],
      ),
      floatingActionButton: _getActionButton(_selectedIndex),
    );
  }
}
