import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provider/app/exception/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth}) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredencial =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredencial.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // ignore: deprecated_member_use
        final loginType = await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginType.isNotEmpty && loginType[0] == 'password') {
          return throw AuthException(message: 'E-mail already in use.');
        } else {
          return throw AuthException(message: 'You are registered with Google Account.');
        }
      } else if (e.code == 'invalid-email') {
        return throw AuthException(message: 'Invalid e-mail.');
      } else if (e.code == 'operation-not-allowed') {
        return throw AuthException(message: 'Operation not allowed.');
      } else if (e.code == 'weak-password') {
        return throw AuthException(message: 'Weak password.');
      } else if (e.code == 'user-disabled') {
        return throw AuthException(message: 'User disabled.');
      } else if (e.code == 'too-many-requests') {
        return throw AuthException(message: 'Too many requests.');
      } else if (e.code == 'network-request-failed') {
        return throw AuthException(message: 'Network request failed.');
      } else if (e.code == 'operation-not-supported-in-this-environment') {
        return throw AuthException(message: 'Operation not supported in this environment.');
      } else if (e.code == 'email-already-in-use') {
        return throw AuthException(message: 'Email already in use.');
      } else if (e.code == 'invalid-credential') {
        return throw AuthException(message: 'Invalid credential.');
      } else if (e.code == 'user-not-found') {
        return throw AuthException(message: 'User not found.');
      } else if (e.code == 'wrong-password') {
        return throw AuthException(message: 'Wrong password.');
      } else if (e.code == 'too-many-requests') {
        return throw AuthException(message: 'Too many requests.');
      } else if (e.code == 'operation-not-supported-in-this-environment') {
        return throw AuthException(message: 'Operation not supported in this environment.');
      } else if (e.code == 'invalid-verification-code') {
        return throw AuthException(message: 'Invalid verification code.');
      } else if (e.code == 'invalid-verification-id') {
        return throw AuthException(message: 'Invalid verification ID.');
      } else if (e.code == 'missing-verification-code') {
        return throw AuthException(message: 'Missing verification code.');
      } else if (e.code == 'missing-verification-id') {
        return throw AuthException(message: 'Missing verification ID.');
      } else if (e.code == 'user-token-expired') {
        return throw AuthException(message: 'User token expired.');
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredencial =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return userCredencial.user;
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          throw AuthException(message: 'User not found.');
        } else if (error.code == 'wrong-password') {
          throw AuthException(message: 'Wrong password.');
        } else if (error.code == 'invalid-email') {
          throw AuthException(message: 'Invalid email.');
        } else if (error.code == 'user-disabled') {
          throw AuthException(message: 'User disabled.');
        } else if (error.code == 'too-many-requests') {
          throw AuthException(message: 'Too many requests.');
        } else {
          throw AuthException(message: error.message ?? 'Unknown error.');
        }
      } else {
        throw AuthException(message: error.toString());
      }
    } finally {}
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginMethods.isEmpty || loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else {
        throw AuthException(message: 'You are registered with Google Account.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException(message: 'User not found.');
      } else if (e.code == 'invalid-email') {
        throw AuthException(message: 'Invalid email.');
      } else if (e.code == 'operation-not-allowed') {
        throw AuthException(message: 'Operation not allowed.');
      } else if (e.code == 'too-many-requests') {
        throw AuthException(message: 'Too many requests.');
      } else {
        throw AuthException(message: e.message ?? 'Unknown error.');
      }
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        throw AuthException(message: 'User not found.');
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        throw AuthException(message: 'Invalid email.');
      } else if (e.code == 'ERROR_OPERATION_NOT_ALLOWED') {
        throw AuthException(message: 'Operation not allowed.');
      } else if (e.code == 'ERROR_TOO_MANY_REQUESTS') {
        throw AuthException(message: 'Too many requests.');
      } else {
        throw AuthException(message: e.message ?? 'Unknown error.');
      }
    } catch (error) {
      throw AuthException(message: error.toString());
    }
  }

  @override
  Future<User?> googleLogin() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw AuthException(message: 'Google sign-in aborted.');
    } else {
      // ignore: deprecated_member_use
      final loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
      if (loginMethods.isEmpty || loginMethods.contains('password')) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        try {
          final userCredential = await _firebaseAuth.signInWithCredential(credential);
          return userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            throw AuthException(message: 'User not found.');
          } else if (e.code == 'wrong-password') {
            throw AuthException(message: 'Wrong password.');
          } else if (e.code == 'invalid-email') {
            throw AuthException(message: 'Invalid email.');
          } else if (e.code == 'user-disabled') {
            throw AuthException(message: 'User disabled.');
          } else if (e.code == 'too-many-requests') {
            throw AuthException(message: 'Too many requests.');
          } else {
            throw AuthException(message: e.message ?? 'Unknown error.');
          }
        } finally {}
      } else if (loginMethods.contains('google.com')) {
        throw AuthException(message: 'You are already registered with Google Account.');
      } else {
        throw AuthException(message: 'You are registered with E-mail. Please login with E-mail.');
      }
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }
}
