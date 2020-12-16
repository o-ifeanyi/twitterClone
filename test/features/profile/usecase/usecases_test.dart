import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/profile/domain/usecase/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';

void main() {
  ProfileRepository profileRepository;
  GetUserProfileUseCase getUserProfile;

  setUp(() {
    profileRepository = MockProfileRepository();
    getUserProfile = GetUserProfileUseCase(profileRepository: profileRepository);
  });

  group('profile repository use case', () {
    test('should return a UserProfileEntity when getUserProfile is successful',
        () async{
      when(profileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final userProfile = await  getUserProfile(PParams(userId: 'test'));

      expect(userProfile, Right(UserProfileEntity()));
      verify(profileRepository.getUserProfile(any));
    });
  });
}
