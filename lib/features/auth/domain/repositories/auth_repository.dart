import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepositoryInterface {
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signUp(
    String fullName,
    String email,
    String password,
  );
  Future<void> resetPassword(String email);
}
