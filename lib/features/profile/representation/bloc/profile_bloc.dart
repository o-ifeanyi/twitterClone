import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/usecase/usecases.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfile;
  final UpdateUserProfileUseCase updateUserProfile;
  final PickImageUseCase pickImageUseCase;
  ProfileBloc(
      {ProfileState initialState,
      this.getUserProfile,
      this.updateUserProfile,
      this.pickImageUseCase})
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
    final userProfileEither = await getUserProfile(PParams(userId: id));
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
    final successEither = await updateUserProfile(PParams(userEntity: entity));
    yield* successEither.fold((failure) async* {
      yield UpdateFailed();
    }, (success) async* {
      yield* _mapFetchUserProfileToEvent(entity.id);
    });
  }

  Stream<ProfileState> _mapPickImageToEvent(
      ImageSource source, bool isCoverPhoto) async* {
        print(isCoverPhoto);
    final imageEither = await pickImageUseCase(
        PParams(source: source, isCoverPhoto: isCoverPhoto));
    yield* imageEither.fold((failure) async* {
      print('nothing');
    }, (image) async* {
      yield isCoverPhoto
          ? PickedCoverImage(pickedCoverImage: image)
          : PickedProfileImage(pickedProfileImage: image);
    });
  }
}
