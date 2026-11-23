import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService instance = AuthService._init();
  AuthService._init();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  /// Loads the persisted Firebase user session, if any
  Future<UserModel?> loadCurrentSession() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      _currentUser = null;
      return null;
    }

    try {
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _currentUser = UserModel.fromMap({
          ...data,
          'user_id': data['user_id'] ?? firebaseUser.uid.hashCode.abs(),
        });
        return _currentUser;
      }

      final fallbackUser = UserModel(
        userId: firebaseUser.uid.hashCode.abs(),
        fName: firebaseUser.displayName ?? 'Student',
        lName: '',
        gmail: firebaseUser.email ?? '',
        password: '',
      );
      _currentUser = fallbackUser;
      return _currentUser;
    } catch (e) {
      final fallbackUser = UserModel(
        userId: firebaseUser.uid.hashCode.abs(),
        fName: firebaseUser.displayName ?? 'Student',
        lName: '',
        gmail: firebaseUser.email ?? '',
        password: '',
      );
      _currentUser = fallbackUser;
      return _currentUser;
    }
  }

  /// Attempts to log in with gmail and password via Firebase Auth
  Future<UserModel?> login(String gmail, String password) async {
    final cleanGmail = gmail.trim().toLowerCase();
    final cleanPass = password.trim();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: cleanGmail,
        password: cleanPass,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) return null;

      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _currentUser = UserModel.fromMap({
          ...data,
          'user_id': data['user_id'] ?? firebaseUser.uid.hashCode.abs(),
        });
        return _currentUser;
      }

      // Fallback profile if Auth account exists without a Firestore document
      final fallbackUser = UserModel(
        userId: firebaseUser.uid.hashCode.abs(),
        fName: firebaseUser.displayName ?? 'Student',
        lName: '',
        gmail: cleanGmail,
        password: cleanPass,
      );
      await _firestore.collection('users').doc(firebaseUser.uid).set({
        ...fallbackUser.toMap(),
        'uid': firebaseUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      _currentUser = fallbackUser;
      return _currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return null;
      }
      throw Exception(e.message ?? 'Login failed. Please try again.');
    }
  }

  /// Registers a new student account in Firebase Auth and Cloud Firestore
  Future<UserModel> register({
    required String fName,
    required String lName,
    required String gmail,
    required String password,
  }) async {
    final cleanGmail = gmail.trim().toLowerCase();
    final cleanFName = fName.trim();
    final cleanLName = lName.trim();
    final cleanPass = password.trim();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: cleanGmail,
        password: cleanPass,
      );

      final firebaseUser = credential.user!;
      final int numericUserId = DateTime.now().millisecondsSinceEpoch;

      await firebaseUser.updateDisplayName('$cleanFName $cleanLName');

      final userData = {
        'uid': firebaseUser.uid,
        'user_id': numericUserId,
        'fName': cleanFName,
        'lName': cleanLName,
        'gmail': cleanGmail,
        'password': cleanPass,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(firebaseUser.uid).set(userData);

      final newUser = UserModel(
        userId: numericUserId,
        fName: cleanFName,
        lName: cleanLName,
        gmail: cleanGmail,
        password: cleanPass,
      );

      _currentUser = newUser;
      return newUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('An account with this Gmail already exists.');
      } else if (e.code == 'weak-password') {
        throw Exception('Password must be at least 6 characters.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Please enter a valid Gmail address.');
      }
      throw Exception(e.message ?? 'Registration failed.');
    }
  }

  /// Updates student profile details in Cloud Firestore and Firebase Auth
  Future<UserModel> updateProfile({
    required int userId,
    required String fName,
    required String lName,
    required String gmail,
    required String password,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('No signed-in student session found.');
    }

    final cleanGmail = gmail.trim().toLowerCase();
    final cleanFName = fName.trim();
    final cleanLName = lName.trim();
    final cleanPass = password.trim();

    try {
      await firebaseUser.updateDisplayName('$cleanFName $cleanLName');

      if (cleanPass.isNotEmpty && _currentUser?.password != cleanPass) {
        await firebaseUser.updatePassword(cleanPass);
      }

      if (cleanGmail != firebaseUser.email?.toLowerCase()) {
        await firebaseUser.verifyBeforeUpdateEmail(cleanGmail);
      }

      await _firestore.collection('users').doc(firebaseUser.uid).update({
        'fName': cleanFName,
        'lName': cleanLName,
        'gmail': cleanGmail,
        'password': cleanPass,
      });

      final updated = UserModel(
        userId: userId,
        fName: cleanFName,
        lName: cleanLName,
        gmail: cleanGmail,
        password: cleanPass,
      );
      _currentUser = updated;
      return updated;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Another user is already using this Gmail address.');
      } else if (e.code == 'requires-recent-login') {
        throw Exception(
            'Please log out and log back in before changing your email or password.');
      }
      throw Exception(e.message ?? 'Failed to update profile.');
    }
  }

  /// Logs out the current student from Firebase Auth
  Future<void> logout() async {
    _currentUser = null;
    await _auth.signOut();
  }
}
