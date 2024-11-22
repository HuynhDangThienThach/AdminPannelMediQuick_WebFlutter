import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';
import '../utils/exceptions/firebase_exceptions.dart';
import '../utils/exceptions/platform_exceptions.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      return snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<String> generateUniqueCategoryId() async {
    try {
      final snapshot = await _db
          .collection('Categories')
          .get();
      final existingIds = snapshot.docs.map((doc) => doc.id).toList();

      int idCounter = 1;
      String newId;
      do {
        newId = idCounter.toString().padLeft(3, '0');
        idCounter++;
      } while (existingIds.contains(newId));
      print('Id của sản phẩm là $newId');
      return newId;

    } catch (e) {
      throw Exception("Lỗi khi tạo ID sản phẩm duy nhất: $e");
    }
  }

  Future<void> saveUserRecord(CategoryModel category) async {
    try {
      if(category.id.isEmpty){
        category.id = _db.collection('Categories').doc().id;
      }
      await _db.collection('Categories').doc(category.id).set(category.toMap());
      print("Category đã được lưu thành công!");
    } catch (e) {
      print("Lưu Category thất bại: $e");
      throw 'Lưu Category thất bại. Vui lòng thử lại';
    }
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final snapshot = await _db.collection('Categories').doc(id).get();
      if (snapshot.exists) {
        return CategoryModel.fromSnapshot(snapshot);
      }
      return null;
    } catch (e) {
      print("Lỗi khi lấy category: $e");
      return null;
    }
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    try {
      final snapshot = await _db.collection('Categories').doc(id).get();
      if (snapshot.exists) {
        await snapshot.reference.update(data);
      } else {
        throw 'Danh mục không tồn tại. Vui lòng thử lại.';
      }
    } catch (e) {
      throw 'Cập nhật danh mục thất bại. Vui lòng thử lại.';
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await FirebaseFirestore.instance.collection('Categories').doc(categoryId).delete();
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi xóa danh mục: $e');
    }
  }

  Future<void> updateCategoryStatusByInternalId(String id, bool status) async {
    try {
      DocumentSnapshot docSnapshot = await _db.collection('Categories').doc(id).get();
      if (docSnapshot.exists) {
        await docSnapshot.reference.update({'IsFeatured': status});
        print("Cập nhật trạng thái thành công");
      } else {
        print("Không tìm thấy tài liệu nào với Id: $id trong collection Categories");
      }
    } catch (e) {
      print("Lỗi khi cập nhật trạng thái Categories: $e");
    }
  }


}
