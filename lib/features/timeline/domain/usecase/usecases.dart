
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/model/stream_converter.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/timeline/domain/repository/timeline_repository.dart.dart';

class FetchTweetUseCase implements UseCase<StreamConverter, NoParams> {
  final TimeLineRepository timeLineRepository;

  FetchTweetUseCase({this.timeLineRepository});
  @override
  Future<Either<TimeLineFailure, StreamConverter>> call(NoParams params) async{
    return await timeLineRepository.fetchTweets();
  }
}