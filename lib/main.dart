import 'package:fc_twitter/bloc/auth_bloc.dart';
import 'package:fc_twitter/bloc/tweet_bloc.dart';
import 'package:fc_twitter/bloc/theme_bloc.dart';
import 'package:fc_twitter/screens/auth_form.dart';
import 'package:fc_twitter/screens/auth_screen.dart';
import 'package:fc_twitter/screens/tweet_screen.dart';
import 'package:fc_twitter/screens/navigation_screen.dart';
import 'package:fc_twitter/util/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.getInstance().then((pref) {
    int index = pref.getInt('theme') ?? 0;
    final darkIndex = pref.getInt('darktheme') ?? 1;
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(InitialAuthState()),
          ),
          BlocProvider<TweetBloc>(
            create: (BuildContext context) => TweetBloc(InitialState()),
          ),
          BlocProvider<ThemeBloc>(
            create: (BuildContext context) => ThemeBloc(
              ThemeState(index == 0
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
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: state.theme,
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
