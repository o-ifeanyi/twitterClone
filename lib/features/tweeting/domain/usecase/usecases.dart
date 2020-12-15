import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/core/usecase/usecase.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';

class SendTweetUseCase implements UseCase<bool, TParams> {
  final TweetingRepository tweetingRepository;

  SendTweetUseCase({this.tweetingRepository});
  @override
  Future<Either<TweetingFailure, bool>> call(TParams params) async{
    return await tweetingRepository.sendTweet(params.tweet);
  }
}