import 'package:fc_twitter/core/util/config.dart';
import 'package:fc_twitter/features/profile/representation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class CoverImage extends StatelessWidget {
  final String imageUrl;

  CoverImage({@required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (_, currentState) {
        return currentState is PickedCoverImage;
      },
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              height: Config.yMargin(context, 18),
              decoration: state.pickedCoverImage != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(state.pickedCoverImage),
                      ),
                    )
                  : BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image:
                            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      ),
                    ),
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
                    .add(PickImage(imageSource: choice, isCoverPhoto: true));
              },
              child: Container(
                height: Config.yMargin(context, 18),
                color: Colors.black38,
                alignment: Alignment.center,
                child: Icon(
                  Feather.camera,
                  size: Config.xMargin(context, 10),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
