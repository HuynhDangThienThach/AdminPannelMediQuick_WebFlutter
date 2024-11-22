import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../models/product_category_model.dart';
import '../models/product_model.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Get limited featured products
  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      final snapshot = await _db.collection('Products').get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to save user data to Firestore.
  Future<void> saveUserRecord(ProductModel pr) async {
    try {
      if (pr.id.isEmpty) {
        pr.id = _db.collection('Products').doc().id;
      }
      await _db.collection("Products").doc(pr.id).set(pr.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> saveProductCategory(String productId, String categoryId) async {
    try {
      final productCategory = ProductCategoryModel(
        productId: productId,
        categoryId: categoryId,
      );
      await _db.collection('ProductCategory').add(productCategory.toJson());
    } catch (e) {
      throw Exception("Lỗi khi lưu ProductCategory: $e");
    }
  }


  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _db.collection('Products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromSnapshot(doc);
      } else {
        throw 'Sản phẩm không tìm thấy!';
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('Products').doc(productId).update(updatedData);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('Products').doc(productId).delete();
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi xóa sản phẩm: $e');
    }
  }

}