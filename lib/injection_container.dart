import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/authentication/data/repository/user_repository.dart';
import 'package:fc_twitter/features/authentication/domain/usecase/use_cases.dart';
import 'package:fc_twitter/features/authentication/representation/bloc/bloc.dart';
import 'package:fc_twitter/features/timeline/data/repository/timeline_repository.dart';
import 'package:fc_twitter/features/timeline/domain/usecase/usecases.dart';
import 'package:fc_twitter/features/timeline/representation/bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'features/authentication/domain/repository/user_repository.dart';
import 'features/timeline/domain/repository/timeline_repository.dart.dart';

final sl = GetIt.instance;
Future<void> init() async{
  // Features Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(
        initialState: sl(),
        signUpNewUser: sl(),
        saveUserDetail: sl(),
        logInUser: sl(),
        logOutUser: sl(),
      ));
  // State
  sl.registerLazySingleton<AuthState >(() => InitialAuthState());

  // Use cases
  sl.registerLazySingleton(() => SignUpNewUser(userRepository: sl()));
  sl.registerLazySingleton(() => SaveUserDetail(userRepository: sl()));
  sl.registerLazySingleton(() => LogInUser(userRepository: sl()));
  sl.registerLazySingleton(() => LogOutUser(userRepository: sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        firebaseAuth: sl(),
        firebaseFirestore: sl(),
      ));

  // Features TimeLine
  // Bloc
  sl.registerFactory(() => TimeLineBloc(
        initialState: sl(),
        fetchTweets: sl(),
        sendTweet: sl(),
      )..add(FetchTweet()));

  // State
  sl.registerLazySingleton<TimeLineState>(() => InitialTimeLineState());

  // Use cases
  sl.registerLazySingleton(() => FetchTweetUseCase(timeLineRepository: sl()));
  sl.registerLazySingleton(() => SendTweetUseCase(timeLineRepository: sl()));

  // Repository
  sl.registerLazySingleton<TimeLineRepository>(() => TimeLineRepositoryImpl(
        firebaseFirestore: sl(),
      ));

  // Externals
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
