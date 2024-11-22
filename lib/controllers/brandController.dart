import 'dart:typed_data';
import 'package:admin/repository/brandRepository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/brand_model.dart';
import '../models/category_model.dart';
import '../repository/category_repository.dart';
import '../utils/validators/loaders.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  //--- Variables
  BrandModel? selectedBrand;
  String? visibilityStatus;
  String imageUrl = '';
  final brandName = TextEditingController();
  final brandCount = TextEditingController();
  RxBool tuyChonHienThi = false.obs;
  final RxList<bool> selectedCategory = <bool>[].obs;
  final RxList<BrandModel> brands = <BrandModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<String> selectedCategories = <String>[].obs;
  GlobalKey<FormState> createBannerFormKey = GlobalKey<FormState>();
  final categoriesRepository = Get.put(CategoryRepository());
  final brandRepository = Get.put(BrandRepository());

  void onInit() {
    super.onInit();
    fetchAllBrands();
    fetchAllCategories();
  }
  //--- Functions
  Future<void> fetchAllBrands() async {
    try {
      final fetchedBrands = await brandRepository.fetchAllBrands();
      brands.assignAll(fetchedBrands);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Chà, thật đáng tiếc!', message: e.toString());
    }
  }
  Future<void> fetchAllCategories() async {
    try {
      final fetchCategories = await categoriesRepository.getAllCategories();
      categories.assignAll(fetchCategories);
      // Khởi tạo selectedCategory với giá trị false cho mỗi danh mục
      selectedCategory.assignAll(List.generate(categories.length, (_) => false));
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
    }
  }


  Future<void> uploadImageToFirebase(Uint8List imageData, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final bannerRef = storageRef.child("brands/$fileName");
      final uploadTask = bannerRef.putData(imageData);

      final snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      print("Tải ảnh thành công, URL: $imageUrl");
    } catch (e) {
      print("Tải ảnh thất bại: $e");
    }
  }

  Future<void> createBrand() async {
    try {
      if (!createBannerFormKey.currentState!.validate()) return;
      createBannerFormKey.currentState!.save();

      final newId = await brandRepository.getMaxId();

      final selectedCategories = categories.asMap().entries
          .where((entry) => selectedCategory[entry.key])
          .map((entry) => entry.value.id)
          .toList();

      final newBrand = BrandModel(
        id: newId.toString(),
        name: brandName.text.trim(),
        image: imageUrl,
        isFeatured: tuyChonHienThi.value,
        productsCount: int.parse(brandCount.text),
      );
      await brandRepository.saveUserRecord(newBrand, newId.toString());
      for (String categoryId in selectedCategories) {
        await brandRepository.saveBrandsCategory(newId.toString(), categoryId);
      }
      TLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Thương hiệu của bạn đã được thêm thành công!',
      );
      clearFields();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Chà, thật đáng tiếc!',
        message: e.toString(),
      );
    }
  }



  Future<void> updateBrand(String brandId) async {
    try {
      if (!createBannerFormKey.currentState!.validate()) return;
      createBannerFormKey.currentState!.save();

      // Cập nhật thông tin thương hiệu trong Firebase
      final updatedBrand = BrandModel(
        id: brandId,
        name: brandName.text.trim(),
        image: imageUrl,
        isFeatured: tuyChonHienThi.value,
        productsCount: int.parse(brandCount.text),
      );
      await brandRepository.saveUserRecord(updatedBrand, brandId);

      // Xóa và cập nhật danh mục đã chọn trong Firebase
      await brandRepository.deleteCategoriesForBrand(brandId);
      for (String categoryId in selectedCategories) {
        await brandRepository.saveBrandsCategory(brandId, categoryId);
      }

      TLoaders.successSnackBar(
        title: 'Cập nhật thành công',
        message: 'Thông tin thương hiệu đã được cập nhật!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi cập nhật',
        message: e.toString(),
      );
    }
  }


  void clearFields() {
    brandName.clear();
    brandCount.clear();
    imageUrl = '';
    tuyChonHienThi.value = false;
    update();
  }

  void setSelectedBrand(BrandModel brand) {
    selectedBrand = brand;
  }
  bool validateCategorySelection() {
    return selectedCategory.any((isSelected) => isSelected == true);
  }
  Future<void> deleteBrand(String brandId) async{
    try{
      await brandRepository.deleteBrand(brandId);
      brands.removeWhere((brand) =>brand.id == brandId);
      TLoaders.successSnackBar(
        title: 'Xóa thành công',
        message: 'Thương hiệu đã được xóa thành công!',
      );
    }catch(e){
      TLoaders.errorSnackBar(
        title: 'Xóa thất bại',
        message: e.toString(),
      );
    }
  }

  Future<void> getBrandById(String brandId) async {
    try {
      // Lấy thông tin thương hiệu
      final brand = await brandRepository.fetchBrandById(brandId);
      selectedCategories.clear();
      selectedCategories.addAll(await brandRepository.fetchCategoriesForBrand(brandId));

      // Cập nhật giao diện
      visibilityStatus = brand.isFeatured! ? 'Hiển thị' : 'Ẩn';
      tuyChonHienThi.value = brand.isFeatured!;
      imageUrl = brand.image;
      brandName.text = brand.name;
      brandCount.text = brand.productsCount.toString();

      // Đồng bộ các danh mục đã chọn
      _updateSelectedCategories();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không tìm thấy brand với ID: $brandId',
      );
    }
  }

  // Cập nhật các danh mục đã chọn
  void _updateSelectedCategories() {
    selectedCategory.clear();
    selectedCategory.addAll(
      categories.map((category) => selectedCategories.contains(category.id)).toList(),
    );
  }

}
