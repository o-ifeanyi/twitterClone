
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';

abstract class TimeLineRepository {
  Future<Either<TimeLineFailure, StreamConverter>> fetchTweets();
}