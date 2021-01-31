import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String userId;
  final DocumentReference userProfile;
  final DocumentReference tweet;
  final bool isSeen;

  NotificationEntity({this.userId ,this.userProfile, this.tweet, this.isSeen});
  @override
  List<Object> get props => [];
}