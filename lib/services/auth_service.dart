import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_model.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signup(
    String email,
    String name,
    String password, {
    String? age,
    String? maritalStatus,
  }) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'age': age,
        'maritalStatus': maritalStatus,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> adminSignup(
    String email,
    String name,
    String password,
    String hospitalName,
    String hospitalAddress,
    String phoneNumber,
  ) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await _firestore.collection('admins').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'hospitalName': hospitalName,
        'hospitalAddress': hospitalAddress,
        'phoneNumber': phoneNumber,
        'role': 'admin',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

Future<void> adminLogin(String email, String password) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // 🔐 Pastikan akun ini memang admin
    final adminDoc =
        await _firestore.collection('admins').doc(uid).get();

    if (!adminDoc.exists) {
      await _auth.signOut();
      throw Exception('Akun ini bukan admin');
    }
  } on FirebaseAuthException catch (e) {
    throw Exception(_handleAuthError(e));
  }
}


 Future<AdminModel?> getCurrentAdmin() async {
  final user = _auth.currentUser;
  if (user == null) return null;

  final doc =
      await _firestore.collection('admins').doc(user.uid).get();

  if (!doc.exists) return null;

  return AdminModel.fromMap(doc.data()!);
}

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.id, doc.data()!);
  }


  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> adminLogout() async {
    await _auth.signOut();
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-not-found':
        return 'Akun tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'weak-password':
        return 'Password terlalu lemah';
      default:
        return e.message ?? 'Terjadi kesalahan';
    }
  }
}
