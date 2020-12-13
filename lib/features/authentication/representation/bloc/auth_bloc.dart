import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/authentication/domain/usecase/use_cases.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpNewUser signUpNewUser;
  final SaveUserDetail saveUserDetail;
  final LogInUser logInUser;
  final LogOutUser logOutUser;
  AuthBloc({
    AuthState initialState,
    this.signUpNewUser,
    this.saveUserDetail,
    this.logInUser,
    this.logOutUser,
  }) : super(initialState);

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUp) {
      yield* _mapSignupToState(event.user);
    }
    if (event is Login) {
      yield* _mapLoginToState(event.user);
    }
    if (event is LogOut) {
      logOutUser(NoParams());
    }
  }

  Stream<AuthState> _mapSignupToState(UserEntity user) async* {
    yield AuthInProgress();
    try {
      final response = await signUpNewUser(AParams(user: user));
      yield* response.fold((failure) async* {
        yield AuthFailed(message: failure.message);
      }, (credentials) async* {
        final savedEither = await saveUserDetail(AParams(credential: credentials));
        yield* savedEither.fold((failure) async* {
          yield AuthFailed(message: failure.message);
        }, (success) async* {
          yield AuthComplete();
        });
      });
      // if signup is successful and saving fails the newly created user should probably be deleted
    } catch (error) {
      print(error);
    }
  }

  Stream<AuthState> _mapLoginToState(UserEntity user) async* {
    yield AuthInProgress();
    try {
      final response = await logInUser(AParams(user: user));
      yield* response.fold((failure) async* {
        yield AuthFailed(message: failure.message);
      }, (credentials) async* {
        yield AuthComplete();
      });
    } catch (error) {
      print(error);
    }
  }
}
