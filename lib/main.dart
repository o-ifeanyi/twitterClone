import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/settings/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:fc_twitter/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/util/themes.dart';
import 'features/authentication/representation/bloc/bloc.dart';
import 'features/authentication/representation/pages/auth_form.dart';
import 'features/authentication/representation/pages/auth_screen.dart';
import 'features/timeline/representation/bloc/bloc.dart';
import 'features/timeline/representation/pages/tweet_screen.dart';
import 'navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Firebase.initializeApp();
  SharedPreferences.getInstance().then((pref) {
    int index = pref.getInt('theme') ?? 0;
    final darkIndex = pref.getInt('darktheme') ?? 1;
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
          BlocProvider<TimeLineBloc>(create: (_) => sl<TimeLineBloc>()),
          BlocProvider<SettingsBloc>(
            create: (BuildContext context) => SettingsBloc(
              appTheme: AppTheme(index == 0
                  ? lightThemeData[index]
                  : darkThemeData[darkIndex]),
            ),
          ),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: (state as AppTheme).theme,
        home: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return NavigationScreen();
              } else {
                return AuthScreen();
              }
            }),
        routes: {
          TweetScreen.pageId: (ctx) => TweetScreen(),
          AuthForm.pageId: (ctx) => AuthForm(),
          NavigationScreen.pageId: (ctx) => NavigationScreen(),
        },
      );
    });
  }
}
