import 'package:fc_twitter/features/profile/representation/pages/edit_profile_screen.dart';
import 'package:fc_twitter/features/profile/representation/pages/profile_screen.dart';
import 'package:fc_twitter/features/settings/representation/bloc/theme_bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/pages/comments_screen.dart';
import 'package:fc_twitter/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/authentication/representation/bloc/bloc.dart';
import 'features/authentication/representation/pages/auth_form.dart';
import 'features/authentication/representation/pages/auth_screen.dart';
import 'features/profile/representation/bloc/profile_bloc.dart';
import 'features/timeline/representation/bloc/bloc.dart';
import 'features/tweeting/representation/pages/tweet_screen.dart';
import 'navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<TimeLineBloc>(create: (_) => sl<TimeLineBloc>()),
        BlocProvider<TweetingBloc>(create: (_) => sl<TweetingBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: state.theme,
          home: StreamBuilder<User>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  profileBloc.add(FetchUserProfile(snapshot.data.uid));
                  return NavigationScreen();
                } else {
                  return AuthScreen();
                }
              }),
          routes: {
            TweetScreen.pageId: (ctx) => TweetScreen(),
            CommentsScreen.pageId: (ctx) => CommentsScreen(),
            AuthForm.pageId: (ctx) => AuthForm(),
            NavigationScreen.pageId: (ctx) => NavigationScreen(),
            ProfileScreen.pageId: (ctx) => ProfileScreen(),
            EditProfileScreen.pageId: (ctx) => EditProfileScreen(),
          },
        );
      },
    );
  }
}
