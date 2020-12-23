import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileBloc({ProfileState initialState, this.profileRepository})
      : super(initialState);

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchUserProfile) {
      yield* _mapFetchUserProfileToEvent(event.userId);
    }
    if (event is UpdateUserProfile) {
      yield* _mapUpdateUserProfileToEvent(event.userEntity);
    }
    if (event is PickImage) {
      yield* _mapPickImageToEvent(event.imageSource, event.isCoverPhoto);
    }
  }

  Stream<ProfileState> _mapFetchUserProfileToEvent(String id) async* {
    yield FetchingUserProfile();
    final userProfileEither = await profileRepository.getUserProfile(id);
    yield* userProfileEither.fold(
      (failure) async* {
        yield FetchingFailed();
      },
      (profile) async* {
        yield FetchingComplete(userProfile: profile);
      },
    );
  }

  Stream<ProfileState> _mapUpdateUserProfileToEvent(
      UserProfileEntity entity) async* {
    if (entity.profilePhoto.runtimeType != String || entity.coverPhoto.runtimeType != String) {
      final uploadEither = await profileRepository.uploadImage(entity);
      yield* uploadEither.fold((failure) async* {
        yield UpdateFailed();
      }, (newProfile) async* {
        entity = newProfile;
      });
    }
    final successEither = await profileRepository.updateUserProfile(entity);
    yield* successEither.fold((failure) async* {
      yield UpdateFailed();
    }, (success) async* {
      yield* _mapFetchUserProfileToEvent(entity.id);
    });
  }

  Stream<ProfileState> _mapPickImageToEvent(
      ImageSource source, bool isCoverPhoto) async* {
    print(isCoverPhoto);
    final imageEither = await profileRepository.pickImage(source, isCoverPhoto);
    yield* imageEither.fold((failure) async* {
      print('nothing');
    }, (image) async* {
      yield isCoverPhoto
          ? PickedCoverImage(pickedCoverImage: image)
          : PickedProfileImage(pickedProfileImage: image);
    });
  }
}
