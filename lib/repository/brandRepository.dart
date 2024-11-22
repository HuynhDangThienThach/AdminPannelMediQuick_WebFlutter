import 'package:admin/models/brand_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/banner_category_model.dart';
import '../utils/exceptions/firebase_exceptions.dart';
import '../utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<BrandModel>> fetchAllBrands() async {
    try {
      final snapshot = await _db.collection('Brands').get();
      return snapshot.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();
    }on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<BrandModel> fetchBrandById(String brandId) async {
    try {
      final docSnapshot = await _db.collection('Brands').doc(brandId).get();
      if (docSnapshot.exists) {
        return BrandModel.fromSnapshot(docSnapshot);
      } else {
        throw 'Thương hiệu không tồn tại';
      }
    } catch (e) {
      throw 'Lỗi khi lấy thông tin thương hiệu: $e';
    }
  }

  Future<List<String>> fetchCategoriesForBrand(String brandId) async {
    try {
      final snapshot = await _db.collection('BrandCategory')
          .where('brandId', isEqualTo: brandId)
          .get();

      return snapshot.docs.map((doc) => doc['categoryId'] as String).toList();
    } catch (e) {
      throw 'Lỗi khi lấy danh mục cho thương hiệu: $e';
    }
  }

  Future<void> deleteCategoriesForBrand(String brandId) async {
    try {
      final snapshot = await _db.collection('BrandCategory')
          .where('brandId', isEqualTo: brandId)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Lỗi khi xóa danh mục cũ: $e';
    }
  }



  Future<void> deleteBrand(String brandId) async {
    try {
      // Lấy tất cả các tài liệu trong BrandCategory có field brandId tương ứng
      final brandCategorySnapshot = await _db
          .collection('BrandCategory')
          .where('brandId', isEqualTo: brandId)
          .get();

      // Kiểm tra và xóa từng tài liệu trong BrandCategory nếu có brandId tương ứng
      if (brandCategorySnapshot.docs.isNotEmpty) {
        for (var doc in brandCategorySnapshot.docs) {
          await _db.collection('BrandCategory').doc(doc.id).delete();
        }
      }

      // Sau khi xóa hết các mục trong BrandCategory, tiếp tục xóa brandId khỏi Brands
      await _db.collection('Brands').doc(brandId).delete();
      print('Xóa thương hiệu và các danh mục liên quan thành công');

    } catch (e) {
      print('Lỗi xóa thương hiệu và danh mục liên quan: $e');
    }
  }



  Future<void> saveUserRecord(BrandModel brand, String newId) async {
    try {
      await _db.collection('Brands').doc(newId).set(brand.toMap());
    } catch (e) {
      throw 'Lưu Brand thất bại. Vui lòng thử lại\n${e}';
    }
  }
  Future<void> saveBrandsCategory(String brandId, String categoryId) async {
    try {
      final newId = await generateUniqueCategoryId();

      final brandCategory = BrandCategoryModel(brandId: brandId, categoryId: categoryId);

      await _db.collection('BrandCategory').doc(newId).set(brandCategory.toJson());
    } catch (e) {
      throw 'Lưu BrandCategory thất bại. Vui lòng thử lại\n$e';
    }
  }

  Future<String> generateUniqueCategoryId() async {
    try {
      final snapshot = await _db.collection('BrandCategory').get();
      final existingIds = snapshot.docs.map((doc) => doc.id).toList();

      int idCounter = 1;
      String newId;
      do {
        newId = idCounter.toString().padLeft(3, '0');
        idCounter++;
      } while (existingIds.contains(newId));
      return newId;

    } catch (e) {
      throw Exception("Lỗi khi tạo ID BrandCategory duy nhất: $e");
    }
  }

  Future<int> getMaxId() async {
    final brands = await fetchAllBrands();
    if (brands.isEmpty) return 1;
    // Tìm id lớn nhất và trả về giá trị đó + 1 để tạo id mới
    return brands.map((brand) => int.tryParse(brand.id) ?? 0).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<void> updateBrandStatusByInternalId(String id, bool status) async {
    try {
      DocumentSnapshot docSnapshot = await _db.collection('Brands').doc(id).get();
      if (docSnapshot.exists) {
        await docSnapshot.reference.update({'IsFeatured': status});
      } else {
        print("Không tìm thấy tài liệu nào với Id: $id trong collection Brands");
      }
    } catch (e) {
      print("Lỗi khi cập nhật trạng thái Brands: $e");
    }
  }
}

