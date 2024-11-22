import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/banner_model.dart';
import '../utils/exceptions/firebase_exceptions.dart';
import '../utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<BannerModel>> getAllFeaturedBanner() async {
    try {
      final snapshot = await _db.collection('Bannerss').get();
      return snapshot.docs.map((e) => BannerModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
  Future<void> saveUserRecord(BannerModel banner) async {
    try {
      await _db.collection('Bannerss').add(banner.toMap());
      print("Banner đã được lưu thành công!");
    } catch (e) {
      print("Lưu banner thất bại: $e");
      throw 'Lưu banner thất bại. Vui lòng thử lại';
    }
  }
  Future<int> getMaxId() async {
    final banners = await getAllFeaturedBanner();
    if (banners.isEmpty) return 1;
    // Tìm id lớn nhất và trả về giá trị đó + 1 để tạo id mới
    return banners.map((banner) => int.tryParse(banner.id) ?? 0).reduce((a, b) => a > b ? a : b) + 1;
  }
  Future<void> deleteBanner(String id) async {
    try {
      // Tìm và xóa banner theo `id`
      final snapshot = await _db.collection('Bannerss').where('Id', isEqualTo: id).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print("Banner đã được xóa thành công!");
    } catch (e) {
      print("Xóa banner thất bại: $e");
      throw 'Xóa banner thất bại. Vui lòng thử lại';
    }
  }

  Future<BannerModel?> getBannerById(String id) async {
    try {
      final snapshot = await _db.collection('Bannerss').where('Id', isEqualTo: id).get();
      if (snapshot.docs.isNotEmpty) {
        return BannerModel.fromSnapshot(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      print("Lỗi khi lấy banner: $e");
      return null;
    }
  }

  Future<void> updateBanner(String id, Map<String, dynamic> data) async {
    try {
      final snapshot = await _db.collection('Bannerss').where('Id', isEqualTo: id).get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update(data);
      }
    } catch (e) {
      print("Cập nhật banner thất bại: $e");
      throw 'Cập nhật banner thất bại. Vui lòng thử lại';
    }
  }

  Future<void> updateBannerStatusByInternalId(String id, bool status) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('Bannerss').where('Id', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        await docSnapshot.reference.update({'Active': status});
      } else {
        print("Không tìm thấy tài liệu nào với Id: $id trong collection Bannerss");
      }
    } catch (e) {
      print("Lỗi khi cập nhật trạng thái banner: $e");
    }
  }

}


