import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../models/userAdmin_model.dart';

class AdminController extends ChangeNotifier {
  UserAdmin? admin;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> fetchAdminData(String userId) async {
    if (userId.isEmpty) {
      print("Error: userId is empty");
      return;
    }
    try {
      DocumentSnapshot doc = await _firestore.collection('Admins').doc(userId).get();
      if (doc.exists) {
        admin = UserAdmin.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        notifyListeners();
      } else {
        print("Error: Admin document does not exist for userId: $userId");
      }
    } catch (e) {
      print("Error fetching admin data: $e");
    }
  }

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    if (userId.isEmpty) {
      print("Error: userId is empty");
      return null;
    }

    try {
      String filePath = 'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.png';
      TaskSnapshot snapshot = await _storage.ref(filePath).putFile(imageFile);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName, String userId) async {
    if (userId.isEmpty) {
      print("Error: userId is empty");
      return null;
    }

    try {
      String filePath = 'profile_images/$userId/$fileName';
      TaskSnapshot snapshot = await _storage.ref(filePath).putData(fileBytes);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }


  Future<void> updateAdminData(String userId, Map<String, dynamic> updatedData) async {
    if (userId.isEmpty) {
      return;
    }
    try {
      await _firestore.collection('Admins').doc(userId).update(updatedData);
      await fetchAdminData(userId);
    } catch (e) {
      print("Error updating admin data: $e");
    }
  }
}
