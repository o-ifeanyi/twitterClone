import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;

  ProfileImage({@required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (_, currentState) {
        return currentState is PickedProfileImage;
      },
      builder: (context, state) {
        return Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: state.pickedProfileImage != null
                  ? FileImage(state.pickedProfileImage)
                  : imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            ),
            GestureDetector(
              onTap: () async {
                final choice = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () =>
                              Navigator.pop(context, ImageSource.camera),
                          child: Text('Take photo'),
                        ),
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () =>
                              Navigator.pop(context, ImageSource.gallery),
                          child: Text('Choose existing photo'),
                        ),
                      ],
                    ),
                  ),
                );
                if (choice == null) {
                  return;
                }
                context
                    .read<ProfileBloc>()
                    .add(PickImage(imageSource: choice, isCoverPhoto: false));
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black12,
                child: Icon(Feather.camera),
              ),
            )
          ],
        );
      },
    );
  }
}
