import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class TweetMediaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Reset extends TweetMediaEvent {}

class PickMultiImages extends TweetMediaEvent {}

class TweetMediaState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialMediaState extends TweetMediaState {}

class MultiImagesLoaded extends TweetMediaState {
  final List<Asset> images;

  MultiImagesLoaded({this.images});
}

class TweetMediaBloc extends Bloc<TweetMediaEvent, TweetMediaState> {
  final TweetingRepository tweetingRepository;
  TweetMediaBloc({TweetMediaState initialState, this.tweetingRepository})
      : super(initialState);

  @override
  Stream<TweetMediaState> mapEventToState(TweetMediaEvent event) async* {
    if (event is Reset) {
      yield InitialMediaState();
    }
    if (event is PickMultiImages) {
      yield* _mapPickMultiImagesToState();
    }
  }

  Stream<TweetMediaState> _mapPickMultiImagesToState() async* {
    final imagesEither = await tweetingRepository.pickImages();
    yield* imagesEither.fold((failure) async* {
      yield InitialMediaState();
      print(failure.message);
    }, (images) async* {
      yield InitialMediaState();
      yield MultiImagesLoaded(images: images);
    });
  }
}
