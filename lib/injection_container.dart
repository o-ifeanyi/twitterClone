import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/core/util/themes.dart';
import 'package:fc_twitter/features/authentication/data/repository/user_repository.dart';
import 'package:fc_twitter/features/authentication/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/notification/representation/bloc/notification_bloc.dart';
import 'package:fc_twitter/features/profile/data/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/profile/representation/bloc/image_picker_bloc.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_tabs_bloc.dart';
import 'package:fc_twitter/features/settings/representation/bloc/theme_bloc.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/comment_bloc.dart';
import 'package:fc_twitter/features/tweeting/data/repository/tweeting_repository.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/tweeting/representation/bloc/tweet_media_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/authentication/domain/repository/user_repository.dart';
import 'features/notification/data/repository/notification_repository.dart';
import 'features/notification/domain/repository/notification_repository.dart';
import 'features/profile/domain/repository/profile_repository.dart.dart';
import 'features/profile/representation/bloc/profile_bloc.dart';
import 'features/settings/data/model/theme_model.dart';
import 'features/settings/data/repository/settings_repository.dart';
import 'features/settings/domain/repository/settings_repository.dart';
import 'features/timeline/domain/repository/timeline_repository.dart.dart';
import 'features/timeline/representation/bloc/timeline_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  final userId = FirebaseAuth.instance.currentUser.uid;
  final sharedPreferences = await SharedPreferences.getInstance();
  // Feature Autheentication
  // Bloc
  sl.registerFactory(() => AuthBloc(
        initialState: sl(),
        userRepository: sl(),
      ));
  // State
  sl.registerLazySingleton<AuthState>(() => InitialAuthState());

  // Repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        firebaseAuth: sl(),
        firebaseFirestore: sl(),
        firebaseMessaging: sl(),
      ));

  // Feature TimeLine
  // Bloc
  sl.registerFactory(() => TimeLineBloc(
        initialState: sl(),
        timeLineRepository: sl(),
      )..add(FetchTweet()));

  sl.registerFactory(() => CommentBloc(
        initialState: sl(),
        timeLineRepository: sl(),
      ));

  // State
  sl.registerLazySingleton<TimeLineState>(() => InitialTimeLineState());
  sl.registerLazySingleton<CommentState>(() => InitialCommentState());

  // Repository
  sl.registerLazySingleton<TimeLineRepository>(() => TimeLineRepositoryImpl(
        firebaseFirestore: sl(),
      ));

  // Feature Profile
  // Bloc
  sl.registerFactory(() => ProfileBloc(
        initialState: sl(),
        profileRepository: sl(),
      ));

  sl.registerFactory(() => ImagePickerBloc(
        initialState: sl(),
        profileRepository: sl(),
      ));

  sl.registerFactory(() => ProfileTabBloc(
        initialState: sl(),
        profileRepository: sl(),
      ));

  // State
  sl.registerLazySingleton<ProfileState>(() => ProfileInitialState());
  sl.registerLazySingleton<ImagePickerState>(() => InitialImagePickerState());
  sl.registerLazySingleton<ProfileTabState>(() => InitialProfileTabState());

  // Repository
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
        firebaseFirestore: sl(),
        firebaseStorage: sl(),
      ));

  // Feature Tweeting
  // Bloc
  sl.registerFactory(() => TweetingBloc(
        initialState: sl(),
        tweetingRepository: sl(),
        notificationRepository: sl(),
      ));

  sl.registerFactory(() => TweetMediaBloc(
        initialState: sl(),
        tweetingRepository: sl()
      ));

  // State
  sl.registerLazySingleton<TweetingState>(() => InitialTweetingState());
  sl.registerLazySingleton<TweetMediaState>(() => InitialMediaState());

  // Repository
  sl.registerLazySingleton<TweetingRepository>(() => TweetingRepositoryImpl(
        firebaseFirestore: sl(),
        firebaseStorage: sl(),
      ));

  // Feature Notification
  // Bloc
  sl.registerFactory(() => NotificationBloc(
        initialState: sl(),
        notificationRepository: sl(),
      )..add(FetchNotifications(userId: userId)));

  // State
  sl.registerLazySingleton<NotificationState>(() => InitialNotificationState());

  // Repository
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(
    firebaseFirestore: sl(),
    firebaseMessaging: sl(),
    httpClient: sl(),
  ));

  // Feature Setting
  // Bloc
  sl.registerFactory(
    () => ThemeBloc(
      appTheme: sl(),
      settingsRepository: sl(),
    ),
  );
  // State
  sl.registerLazySingleton<AppTheme>(() {
    final theme = json.decode(sharedPreferences.getString('theme') ??
        json.encode({'isLight': true, 'isDim': false, 'isLightsOut': true}));
    final currentTheme = ThemeModel.fromJson(theme).toEntity();
    if (currentTheme.isLight) {
      return AppTheme(themeOptions[ThemeOptions.Light]);
    } else if (currentTheme.isDim) {
      return AppTheme(themeOptions[DarkThemeOptions.Dim]);
    } else
      return AppTheme(themeOptions[DarkThemeOptions.LightsOut]);
  });

  // Repository
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(
        sharedPreferences: sl(),
      ));

  // Externals
  sl.registerLazySingleton<Client>(() => Client());
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging());
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
