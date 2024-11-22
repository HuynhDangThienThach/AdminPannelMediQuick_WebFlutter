import 'dart:typed_data';
import 'package:admin/repository/banner_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/banner_model.dart';
import '../utils/validators/loaders.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();
  final bannerRepository = Get.put(BannerRepository());
  final redirect = TextEditingController();
  String? visibilityStatus;
  RxBool tuyChonHienThi = false.obs;
  GlobalKey<FormState> createProductFormKey = GlobalKey<FormState>();
  final banners = <BannerModel>[].obs;
  String imageUrl = '';
  @override
  void onInit() {
    super.onInit();
    fetchAllFeaturedBanner();
  }

  void clearFields() {
    redirect.clear();
    tuyChonHienThi.value = false;
    visibilityStatus = null;
    imageUrl = '';
  }

  Future<void> fetchAllFeaturedBanner() async {
    try {
      final fetchedBanners = await bannerRepository.getAllFeaturedBanner();
      banners.assignAll(fetchedBanners);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Chà, thật đáng tiếc!', message: e.toString());
    }
  }

  Future<void> uploadImageToFirebase(Uint8List imageData, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final bannerRef = storageRef.child("banners/$fileName");
      final uploadTask = bannerRef.putData(imageData);

      final snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      print("Tải ảnh thành công, URL: $imageUrl");
    } catch (e) {
      print("Tải ảnh thất bại: $e");
    }
  }

  Future<void> createBanner() async {
    try {
      if (!createProductFormKey.currentState!.validate()) return;
      createProductFormKey.currentState!.save();

      final newId = await bannerRepository.getMaxId();

      final newBanner = BannerModel(
        id: newId.toString(),
        active: tuyChonHienThi.value,
        imageUrl: imageUrl,
        targetScreen: redirect.text.trim(),
      );

      await bannerRepository.saveUserRecord(newBanner);
      TLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Sự kiện của bạn đã được thêm thành công!',
      );
      clearFields();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Chà, thật đáng tiếc!',
        message: e.toString(),
      );
    }
  }
  Future<void> updateBanner(String bannerId) async {
    try {
      if (imageUrl.isEmpty) {
        throw Exception("Image URL không hợp lệ");
      }

      final updatedBanner = BannerModel(
        id: bannerId,
        active: tuyChonHienThi.value,
        imageUrl: imageUrl,
        targetScreen: redirect.text.trim(),
      );

      await bannerRepository.updateBanner(bannerId, updatedBanner.toMap());
      TLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Sự kiện của bạn đã cập nhật thành công!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Cập nhật sự kiện thất bại',
      );
    }
  }
  Future<void> deleteBanner(String id) async {
    try {
      await bannerRepository.deleteBanner(id);
      await fetchAllFeaturedBanner();
      TLoaders.successSnackBar(
        title: 'Đã xóa',
        message: 'Banner đã được xóa thành công!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: e.toString(),
      );
    }
  }

  Future<void> getBannerById(String bannerId) async {
    try {
      final snapshot = await bannerRepository.getBannerById(bannerId);
      if (snapshot != null) {
        visibilityStatus = snapshot.active ? 'Hiển thị' : 'Ẩn';
        tuyChonHienThi.value = snapshot.active;
        redirect.text = snapshot.targetScreen;
        imageUrl = snapshot.imageUrl;
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không tìm thấy banner với ID: $bannerId',
      );
    }
  }

}
