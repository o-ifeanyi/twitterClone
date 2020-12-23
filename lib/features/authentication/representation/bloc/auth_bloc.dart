import 'package:fc_twitter/features/authentication/domain/repository/user_repository.dart';
import 'package:fc_twitter/features/authentication/domain/user_entity/user_entity.dart';
import 'package:fc_twitter/features/profile/data/model/user_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  AuthBloc({
    AuthState initialState,
    this.userRepository,
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
      userRepository.logOutUser();
    }
  }

  Stream<AuthState> _mapSignupToState(UserEntity user) async* {
    yield AuthInProgress();

    final response = await userRepository.signUpNewUser(user);
    yield* response.fold((failure) async* {
      yield AuthFailed(message: failure.message);
    }, (credentials) async* {
      final userProfile = UserProfileModel(
        id: credentials.user.uid,
        name: user.email.split('@').first,
        userName: '@' + user.userName,
        dateJoined: _getDate(),
      );
      final savedEither = await userRepository.saveUserDetail(userProfile);
      yield* savedEither.fold((failure) async* {
        yield AuthFailed(message: failure.message);
      }, (success) async* {
        yield AuthComplete();
      });
    });
    // if signup is successful and saving fails the newly created user should probably be deleted
  }

  Stream<AuthState> _mapLoginToState(UserEntity user) async* {
    yield AuthInProgress();
    final response = await userRepository.logInUser(user);
    yield* response.fold((failure) async* {
      yield AuthFailed(message: failure.message);
    }, (credentials) async* {
      yield AuthComplete();
    });
  }

  static String _getDate() {
    final date = DateTime.now();
    final months = [
      'January',
      'Februrary',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return 'Joined ${months[date.month - 1]} ${date.year}';
  }
}
