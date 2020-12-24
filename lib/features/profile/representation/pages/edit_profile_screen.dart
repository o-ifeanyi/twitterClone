import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/image_picker_bloc.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:fc_twitter/features/profile/representation/widgets/cover_image.dart';
import 'package:fc_twitter/features/profile/representation/widgets/profile_image.dart';
import 'package:fc_twitter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  static const String pageId = '/editProfile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();
  String profileImage;
  String coverImage;
  UserProfileEntity profile;
  bool nameIsEmpty = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    profile = ModalRoute.of(context).settings.arguments;
    _nameController.text = profile.name;
    _bioController.text = profile.bio;
    _locationController.text = profile.location;
    _websiteController.text = profile.website;
    profileImage = profile.profilePhoto;
    coverImage = profile.coverPhoto;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text('Edit profile'),
        actions: [
          FlatButton(
            onPressed: nameIsEmpty
                ? null
                : () {
                    final newProfile = profile.copyWith(
                      name: _nameController.text,
                      bio: _bioController.text,
                      location: _locationController.text,
                      website: _websiteController.text,
                    );
                    context
                        .read<ProfileBloc>()
                        .add(UpdateUserProfile(newProfile));
                    Navigator.pop(context);
                  },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: Config.textSize(context, 4),
                color: nameIsEmpty
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height + 150,
          child: BlocProvider<ImagePickerBloc>(
            create: (ctx) => sl<ImagePickerBloc>(),
            child: Stack(
              children: [
                BlocListener<ImagePickerBloc, ImagePickerState>(
                  listener: (context, state) {
                    if (state is PickedCoverImage) {
                      print('setting photo');
                      profile =
                          profile.copyWith(coverPhoto: state.pickedCoverImage);
                    }
                  },
                  child: CoverImage(imageUrl: coverImage),
                ),
                Positioned(
                  top: Config.yMargin(context, 14),
                  child: Container(
                    width: mediaQuery.size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocListener<ImagePickerBloc, ImagePickerState>(
                          listener: (context, state) {
                            if (state is PickedProfileImage) {
                              print('setting photo');
                              profile = profile.copyWith(
                                  profilePhoto: state.pickedProfileImage);
                            }
                          },
                          child: ProfileImage(imageUrl: profileImage),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Name cannot be blank',
                          ),
                          onChanged: (_) {
                            setState(() {
                              nameIsEmpty = _nameController.text.isEmpty;
                            });
                          },
                        ),
                        TextField(
                          controller: _bioController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Bio',
                          ),
                        ),
                        TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: 'Location',
                          ),
                        ),
                        TextField(
                          controller: _websiteController,
                          decoration: InputDecoration(
                            labelText: 'Website',
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Birth date',
                            hintText: 'Add your date of birth',
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
