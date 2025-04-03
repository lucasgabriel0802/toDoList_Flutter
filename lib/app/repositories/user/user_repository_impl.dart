import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_provider/app/exception/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth}) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredencial =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredencial.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'email-already-in-use') {
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
}
