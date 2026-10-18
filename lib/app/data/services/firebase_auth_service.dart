import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _googleReady = false;

  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    _initGoogle();
  }

  Future<void> _initGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      _googleReady = true;
    } on Object catch (error) {
      debugPrint('Google Sign-In init skipped: $error');
      _googleReady = false;
    }
  }

  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.message ?? 'An error occurred during login',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Auth Failed',
        e.message ?? 'Could not continue as guest',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (!_googleReady) {
        await _initGoogle();
      }
      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = account.authentication;
      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        Get.snackbar(
          'Google Sign-In',
          'Could not get Google ID token. Check Firebase OAuth client setup.',
        );
        return null;
      }
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Google Sign-In', e.message ?? 'Sign-in failed');
      return null;
    } on Object catch (e) {
      Get.snackbar(
        'Google Sign-In',
        'Google login needs an OAuth client in Firebase (SHA-1). $e',
      );
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } on Object {
      // ignore
    }
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
