import 'package:admin/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/AddressModel.dart';
import '../models/order_model.dart';
import '../utils/exceptions/firebase_exceptions.dart';
import '../utils/exceptions/platform_exceptions.dart';
import '../utils/validators/enums.dart';

class CustomerRepository extends GetxController {
  static CustomerRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  
  Future<List<UserModel>> fetchAllCustomer() async {
    try {
      final snapshot = await _db.collection('Users').get();
      return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    }on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final userSnapshot = await _db.collection("Users").doc(id).get();
      if (userSnapshot.exists) {

        final user = UserModel.fromSnapshot(userSnapshot);

        final addressesSnapshot = await _db.collection("Users").doc(id).collection("Addresses").get();
        final addresses = addressesSnapshot.docs.map((doc) {
          return AddressModel.fromDocumentSnapshot(doc);
        }).toList();
        user.addresses = addresses;


        final ordersSnapshot = await _db.collection("Users").doc(id).collection("Orders").get();
        final orders = ordersSnapshot.docs.map((doc) {
          return OrderModel.fromSnapshot(doc);
        }).toList();
        user.orders = orders;

        return user;
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
    return null;
  }
  Future<List<OrderModel>> fetchOrdersByUserId(String userId) async {
    try {
      final ordersSnapshot = await _db.collection("Users").doc(userId).collection("Orders").get();
      return ordersSnapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching orders for user $userId. Please try again';
    }
  }

  Future<String?> getOrderDocumentIdByOrderId({required String userId, required String orderId}) async {
    try {
      // Truy cập collection Orders trong Firestore
      final ordersSnapshot = await _db.collection('Users').doc(userId).collection('Orders').get();

      // Tìm document có `id` trùng với `orderId`
      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        if (data['id'] == orderId) {
          return doc.id; // Trả về document ID
        }
      }
      return null; // Nếu không tìm thấy
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: ${e.message}';
    } catch (e) {
      throw 'Unexpected Error: $e';
    }
  }

  Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    try {
      final orderRef = _db
          .collection("Users")
          .doc(userId)
          .collection("Orders")
          .doc(orderId);

      await orderRef.update({
        "status": newStatus.toString(),
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating order status. Please try again.';
    }
  }

}
