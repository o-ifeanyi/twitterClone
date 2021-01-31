import 'package:fc_twitter/features/notification/domain/entity/notification_entity.dart';
import 'package:fc_twitter/features/notification/representation/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_item.dart';

class AllNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      // buildWhen: (_, currentState) {
      //   return currentState is FetchingNotificationsComplete;
      // },
      builder: (context, state) {
        if (state is FetchingNotificationsComplete) {
          return StreamBuilder<List<NotificationEntity>>(
            stream: state.notificationStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, index) => NotificationItem(
                        notification: snapshot.data[index],
                      ),
                    )
                  : Center(child: Text('nothing'));
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
