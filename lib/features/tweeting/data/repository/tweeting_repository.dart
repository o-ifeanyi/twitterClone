import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/tweeting/data/model/tweet_model.dart';
import 'package:fc_twitter/features/tweeting/domain/entity/tweet_entity.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class TweetingRepositoryImpl implements TweetingRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  TweetingRepositoryImpl({this.firebaseFirestore, this.firebaseStorage})
      : assert(firebaseFirestore != null);

  @override
  Future<Either<TweetingFailure, bool>> comment(
      {UserProfileEntity userProfile,
      TweetEntity tweet,
      TweetEntity commentTweet}) async {
    try {
      int comments = tweet.noOfComments;
      comments++;
      tweet = tweet.copyWith(noOfComments: comments);
      await firebaseFirestore
          .collection('tweets')
          .doc(tweet.id)
          .update({'noOfComments': comments});
      commentTweet = commentTweet.copyWith(
          commentTo: firebaseFirestore.collection('tweets').doc(tweet.id),
          userProfile:
              firebaseFirestore.collection('users').doc(userProfile.id));
      await firebaseFirestore
          .collection('tweets')
          .add(TweetModel.fromEntity(commentTweet).toMap());
      if (tweet.isRetweet) {
        await firebaseFirestore
            .collection('tweets')
            .doc(tweet.retweetTo.id)
            .update({'noOfComments': comments});
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to comment'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> sendTweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      tweet = tweet.copyWith(
          userProfile:
              firebaseFirestore.collection('users').doc(userProfile.id));
      await firebaseFirestore
          .collection('tweets')
          .add(TweetModel.fromEntity(tweet).toMap());
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to send tweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> likeTweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final likedBy = tweet.likedBy;
      likedBy?.add(firebaseFirestore.collection('users').doc(userProfile.id));
      tweet = tweet.copyWith(likedBy: likedBy);
      await firebaseFirestore
          .collection('tweets')
          .doc(tweet.id)
          .update({'likedBy': likedBy});
      if (tweet.isRetweet) {
        await firebaseFirestore
            .collection('tweets')
            .doc(tweet.retweetTo.id)
            .update({'likedBy': likedBy});
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to like tweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> unlikeTweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final likedBy = tweet.likedBy;
      likedBy?.removeWhere((element) =>
          (element as DocumentReference).path.endsWith(userProfile.id));
      tweet = tweet.copyWith(likedBy: likedBy);
      await firebaseFirestore
          .collection('tweets')
          .doc(tweet.id)
          .update({'likedBy': likedBy});
      if (tweet.isRetweet) {
        await firebaseFirestore
            .collection('tweets')
            .doc(tweet.retweetTo.id)
            .update({'likedBy': likedBy});
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to like tweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> retweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final retweetedBy = tweet.retweetedBy;
      retweetedBy
          ?.add(firebaseFirestore.collection('users').doc(userProfile.id));
      tweet = tweet.copyWith(retweetedBy: retweetedBy);
      await firebaseFirestore
          .collection('tweets')
          .doc(tweet.id)
          .update({'retweetedBy': retweetedBy});
      tweet = tweet.copyWith(
          isRetweet: true,
          commentTo: null, // if its a comment the retweet also show in comments
          retweetTo: firebaseFirestore.collection('tweets').doc(tweet.id),
          retweetersProfile:
              firebaseFirestore.collection('users').doc(userProfile.id));
      await firebaseFirestore
          .collection('tweets')
          .add(TweetModel.fromEntity(tweet).toMap());
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to retweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> undoRetweet(
      UserProfileEntity userProfile, TweetEntity tweet) async {
    try {
      final retweetedBy = tweet.retweetedBy;
      retweetedBy?.removeWhere((element) =>
          (element as DocumentReference).path.endsWith(userProfile.id));
      tweet = tweet.copyWith(retweetedBy: retweetedBy);
      await firebaseFirestore
          .collection('tweets')
          .doc(tweet.id)
          .update({'retweetedBy': retweetedBy});
      if (tweet.isRetweet ?? false) {
        await firebaseFirestore
            .collection('tweets')
            .doc(tweet.retweetTo.id)
            .update({'retweetedBy': retweetedBy});
        // await undoRetweet(userProfile, tweet.retweetTo);
        await firebaseFirestore.collection('tweets').doc(tweet.id).delete();
      }
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to retweet'));
    }
  }

  @override
  Future<Either<TweetingFailure, List<Asset>>> pickImages() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        // selectedAssets: images,
        // cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000000",
          statusBarColor: "#000000",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      return Right(resultList);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to load images'));
    }
  }

  @override
  Future<Either<TweetingFailure, List<String>>> uploadImages(
      List<Asset> images) async {
    try {
      final List<String> imageLinks = [];
      for (var image in images) {
        final filePath =
            await FlutterAbsolutePath.getAbsolutePath(image.identifier);
        final ref = firebaseStorage
            .ref()
            .child('tweetImages')
            .child(image.hashCode.toString());
        await ref.putFile(File(filePath)).whenComplete(() async {
          final imageUrl = await ref.getDownloadURL();
          imageLinks.add(imageUrl);
        });
      }
      return Right(imageLinks);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to upload image'));
    }
  }

  @override
  Future<Either<TweetingFailure, bool>> quoteTweet(
      {UserProfileEntity userProfile,
      TweetEntity tweet,
      TweetEntity quoteTweet}) async {
    try {
      tweet = tweet.copyWith(
        userProfile: firebaseFirestore.collection('users').doc(userProfile.id),
        isQuote: true,
        quoteTo: firebaseFirestore.collection('tweets').doc(quoteTweet.id),
      );
      final reference = await firebaseFirestore
          .collection('tweets')
          .add(TweetModel.fromEntity(tweet).toMap());

      final quotedBy = quoteTweet.quotedBy;
      quotedBy?.add(reference);
      
      await firebaseFirestore
          .collection('tweets')
          .doc(quoteTweet.id)
          .update({'quotedBy': quotedBy});
      return Right(true);
    } catch (error) {
      print(error);
      return Left(TweetingFailure(message: 'Failed to quote tweet'));
    }
  }
}
