import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_todolist/core/cache.dart';
import 'package:web_todolist/modules/auth/models/user.dart' as user;
import 'package:web_todolist/modules/auth/models/user.dart';

final String AUTH_STATUS = 'auth-status';
final String AUTH_UID = 'auth-uid';

class LogInWithGoogleFailure implements Exception {}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({
    CacheClient cache,
    firebase_auth.FirebaseAuth firebaseAuth,
    SharedPreferences sharedPreferences,
    GoogleSignIn googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _sharedPreferences =
            sharedPreferences ?? SharedPreferences.getInstance();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _sharedPreferences;
  final CacheClient _cache;

  static const userCacheKey = '__user_cache_key__';

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      User user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  saveUser() async {
    await _sharedPreferences.setBool(AUTH_STATUS, true);
    await _sharedPreferences.setString(AUTH_UID, currentUser.id);
  }

  Future<String> getId() async {
    var status = await _sharedPreferences.getBool(AUTH_STATUS);
    if (!status) {
      return null;
    }
    return await _sharedPreferences.getString(AUTH_UID);
  }

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      saveUser();
    } on Exception catch (e) {
      print(e.toString());
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> logInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on Exception catch (e) {
      print(e.toString());
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _cache.write(key: userCacheKey, value: null);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  user.User get toUser {
    return user.User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
