import 'package:fc_twitter/features/notification/representation/bloc/notification_bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/messaging/representation/pages/message_screen.dart';
import 'features/messaging/representation/widgets/new_message_icon.dart';
import 'features/notification/representation/pages/notification_screen.dart';
import 'features/notification/representation/widgets/notification_icon.dart';
import 'features/profile/representation/pages/drawer.dart';
import 'features/searching/representation/pages/search_screen.dart';
import 'features/timeline/representation/pages/home_screen.dart';
import 'features/tweeting/representation/widgets/new_tweet_icon.dart';

class NavigationScreen extends StatefulWidget {
  static const String pageId = '/navigation';
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final userId = FirebaseAuth.instance.currentUser.uid;
  
  BottomNavigationBarItem _barItem(int index) {
    final theme = Theme.of(context);
    switch (index) {
      case 0:
        return BottomNavigationBarItem(
          label: '',
          activeIcon: Icon(Icons.home, color: theme.primaryColor),
          icon: Stack(
            overflow: Overflow.visible,
            children: [
              Icon(
                Icons.home_outlined,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        );
        break;
      case 1:
        return BottomNavigationBarItem(
          label: '',
          activeIcon: Icon(Icons.search, color: theme.primaryColor),
          icon: Stack(
            overflow: Overflow.visible,
            children: [
              Icon(
                Icons.search_outlined,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        );
        break;
      case 2:
        return BottomNavigationBarItem(
          label: '',
          icon: NotificationIcon(isActive: index == _selectedIndex),
        );
        break;
      case 3:
        return BottomNavigationBarItem(
          label: '',
          activeIcon: Icon(Icons.mail, color: theme.primaryColor),
          icon: Stack(
            overflow: Overflow.visible,
            children: [
              Icon(
                Icons.mail_outline,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        );
        break;
      default:
      return null;
    }
  }

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg) {
        print('onMessage ==> $msg');
        context
            .read<NotificationBloc>()
            .add(FetchNotifications(userId: userId));
        return;
      },
      onLaunch: (msg) {
        print('onLaunch ==> $msg');
        return;
      },
      onResume: (msg) {
        print('onResume ==> $msg');
        return;
      },
    );
  }

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
        child: BlocListener<TweetingBloc, TweetingState>(
          listener: (context, state) {
            if (state is TweetingError) {
              state.showSnackBar(context, _scaffoldKey, state.message, 2,
                  isError: true);
            }
          },
          child: IndexedStack(
            children: _pages,
            index: _selectedIndex,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (newIndex) {
          if (_selectedIndex == 2 && newIndex != 2) {
            context.read<NotificationBloc>().add(MarkAllAsSeen(userId: userId));
          }
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        items: [
          _barItem(0),
          _barItem(1),
          _barItem(2),
          _barItem(3),
        ],
      ),
      floatingActionButton:
          _selectedIndex < 3 ? NewTweetIcon() : NewMessageIcon(),
    );
  }
}