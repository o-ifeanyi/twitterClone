import 'package:fc_twitter/util/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MediaPreview extends StatelessWidget {
  final int index;
  MediaPreview(this.index);
  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: Config.xMargin(context, 20),
          child: IconButton(
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Theme.of(context).primaryColor,
              size: Config.xMargin(context, 10),
            ),
            onPressed: () {},
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Theme.of(context).accentColor, width: 0.5),
          ),
        );
        break;
      case 14:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: Config.xMargin(context, 20),
          child: IconButton(
            icon: Icon(
              Feather.image,
              color: Theme.of(context).primaryColor,
              size: Config.xMargin(context, 10),
            ),
            onPressed: () {},
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 0.5,
              color: Theme.of(context).accentColor,
            ),
          ),
        );
      default:
        return Container(
          width: Config.xMargin(context, 20),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).accentColor,
          ),
        );
    }
  }
}
