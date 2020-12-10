import 'package:fc_twitter/features/authentication/data/model/user_model.dart';
import 'package:fc_twitter/features/authentication/data/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepositoryImpl repositoryImpl;
  AuthBloc({AuthState initialState, this.repositoryImpl}) : super(initialState);

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUp) {
      yield* _mapSignupToState(event.user);
    }
    if (event is Login) {
      yield* _mapLoginToState(event.user);
    }
    if (event is LogOut) {
      repositoryImpl.logOutUser();
    }
  }

  Stream<AuthState> _mapSignupToState(UserModel user) async* {
    yield AuthInProgress();
    try {
      final response = await repositoryImpl.signUpNewUser(user);
      yield* response.fold((failure) async* {
        yield AuthFailed(message:failure.message);
      }, (credentials) async* {
        final savedEither = await repositoryImpl.saveUserDetail(credentials);
        yield* savedEither.fold((failure) async* {
          yield AuthFailed(message:failure.message);
        }, (success) async* {
          yield AuthComplete();
        });
        yield AuthComplete();
      });
    } catch (error) {
      print(error);
    }
  }

  Stream<AuthState> _mapLoginToState(UserModel user) async* {
    yield AuthInProgress();
    try {
      final response = await repositoryImpl.logInUser(user);
      yield* response.fold((failure) async* {
        yield AuthFailed(message:failure.message);
      }, (credentials) async* {
        yield AuthComplete();
      });
    } catch (error) {
      print(error);
    }
  }
}
