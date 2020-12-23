
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_twitter/features/authentication/domain/repository/user_repository.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:fc_twitter/features/settings/domain/repository/settings_repository.dart';
import 'package:fc_twitter/features/timeline/domain/repository/timeline_repository.dart.dart';
import 'package:fc_twitter/features/tweeting/domain/repository/tweeting_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/mockito.dart';

// Repositories
class MockUserRepository extends Mock implements UserRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockTimeLineRepository extends Mock implements TimeLineRepository {}

class MockTweetingRepository extends Mock implements TweetingRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}


// Externals
class MockCollectionReference extends Mock implements CollectionReference {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseStorage  extends Mock implements FirebaseStorage {}

class MockReference  extends Mock implements Reference {}

class MockUserCredential extends Mock implements UserCredential {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockFireBaseAuth extends Mock implements FirebaseAuth {}

class MockFireBaseUser extends Mock implements User {}

class MockDocumentReference extends Mock implements DocumentReference {}


