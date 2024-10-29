import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/userAdmin_model.dart';

class UserAdminRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserAdmin?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        print('Logged in user UID: ${userCredential.user!.uid}'); // Debug print
        final userData = await _firestore
            .collection('Admins')
            .doc(userCredential.user!.uid) // This should be "1"
            .get();

        if (userData.exists) {
          String userRole = userData.data()?['Roles'] ?? '';
          if (userRole == 'admin') {
            return UserAdmin.fromMap(userData.data()!, userCredential.user!.uid);
          } else {
            await _auth.signOut();
            throw Exception("Người dùng không có quyền truy cập");
          }
        } else {
          await _auth.signOut();
          throw Exception("User data not found in Firestore");
        }
      }
    } catch (e) {
      print('Login failed: $e');
      if (e is FirebaseAuthException) {
        print('Error Code: ${e.code}');
        print('Error Message: ${e.message}');
      }
    }
    return null;
  }



  Future<void> logout() async {
    await _auth.signOut();
  }
}
