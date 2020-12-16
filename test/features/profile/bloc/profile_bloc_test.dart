import 'package:dartz/dartz.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/usecase/usecases.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  GetUserProfileUseCase getUserProfile;
  ProfileBloc profileBloc;

  setUp(() {
    getUserProfile = MockGetUserProfile();
    profileBloc = ProfileBloc(
      getUserProfile: getUserProfile,
      initialState: ProfileInitialState(),
    );
  });

  test('confirm initial state', () {
    expect(profileBloc.state, equals(ProfileInitialState()));
  });

  group('profile bloc', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(FetchUserProfile('userId'));
    });
  });
}
