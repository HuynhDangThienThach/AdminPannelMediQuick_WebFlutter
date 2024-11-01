import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userAdmin_model.dart';

class AdminController extends ChangeNotifier {
  UserAdmin? admin;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchAdminData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Admins').doc(userId).get();
      if (doc.exists) {
        admin = UserAdmin.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching admin data: $e");
    }
  }
}
