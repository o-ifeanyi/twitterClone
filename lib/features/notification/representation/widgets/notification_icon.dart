import 'package:fc_twitter/features/notification/representation/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({@required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Icon(
          isActive ? Icons.notifications : Icons.notifications_none_outlined,
          color: isActive ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
        ),
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is FetchingNotificationsComplete) {
              return state.notificationCount < 1
                  ? SizedBox.shrink()
                  : Positioned(
                      right: -7,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2),
                        ),
                        child: Text(
                          state.notificationCount.toString(),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
