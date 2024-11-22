import 'dart:typed_data';
import 'package:admin/models/category_model.dart';
import 'package:admin/repository/category_repository.dart';
import 'package:admin/utils/validators/loaders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();
  final categoriesRepository = Get.put(CategoryRepository());
  final categoriesName = TextEditingController();
  String? visibilityStatus;
  String imageUrl = '';
  String? selectedCategoryName;
  String? parentID;
  RxBool tuyChonHienThi = false.obs;
  GlobalKey<FormState> createCategoriesFormKey = GlobalKey<FormState>();
  final RxList<Map<String, dynamic>> categoriesList = <Map<String, dynamic>>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  CategoryModel? selectedCategory;

  @override
  void onInit() {
    super.onInit();
    fetchAllCategories();
    fetchAllNameCategories();
  }

  //--- Functions
  Future<void> fetchAllCategories() async {
    try {
      final fetchCategories = await categoriesRepository.getAllCategories();
      categories.assignAll(fetchCategories);
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
    }
  }


  Future<void> fetchAllNameCategories() async {
    try {
      final fetchCategories = await categoriesRepository.getAllCategories();
      categories.assignAll(fetchCategories);
      // Lưu nameCategory và id của từng danh mục vào categoriesList
      categoriesList.assignAll(fetchCategories.map((category) =>
      {
        'Name': category.name,
        'Id': category.id,
        'ParentId': category.parentId,
      }).toList());
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
    }
  }

  Future<void> uploadImageToFirebase(Uint8List imageData, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final bannerRef = storageRef.child("categories/$fileName");
      final uploadTask = bannerRef.putData(imageData);

      final snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      print("Tải ảnh thành công, URL: $imageUrl");
    } catch (e) {
      print("Tải ảnh thất bại: $e");
    }
  }

  Future<void> createCategory() async {
    try {
      if (!createCategoriesFormKey.currentState!.validate()) return;
      createCategoriesFormKey.currentState!.save();

      final newId = await categoriesRepository.generateUniqueCategoryId();

      final newCategory = CategoryModel(
          id: newId.toString(),
          name: categoriesName.text.trim(),
          image: imageUrl,
          isFeatured: tuyChonHienThi.value,
          parentId: parentID!,
      );
      await categoriesRepository.saveUserRecord(newCategory);
      TLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Danh mục của bạn đã được thêm thành công!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Chà, thật đáng tiếc!',
        message: e.toString(),
      );
    }
  }

  Future<void> updateCategory(String categoryId) async {
    try {
      if (imageUrl.isEmpty) {
        throw Exception("Image URL không hợp lệ");
      }

      final updatedCategory = CategoryModel(
        id: categoryId,
        isFeatured: tuyChonHienThi.value,
        image: imageUrl,
        name: categoriesName.text.trim(),
        parentId: parentID!,
      );

      await categoriesRepository.updateCategory(categoryId, updatedCategory.toMap());
      TLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Danh mục của bạn đã cập nhật thành công!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Cập nhật danh mục thất bại',
      );
    }
  }

  Future<void> deleteCategories(String categoryId) async{
    try{
      await categoriesRepository.deleteCategory(categoryId);
      categories.removeWhere((categories) =>categories.id == categoryId);
      TLoaders.successSnackBar(
        title: 'Xóa thành công',
        message: 'Danh mục đã được xóa thành công!',
      );
    }catch(e){
      TLoaders.errorSnackBar(
        title: 'Xóa thất bại',
        message: e.toString(),
      );
    }
  }

  Future<void> getCategoryById(String categoryId) async{
    try{
      final snapshot = await categoriesRepository.getCategoryById(categoryId);
      if (snapshot != null) {
        visibilityStatus = snapshot.isFeatured ? 'Hiển thị' : 'Ẩn';
        tuyChonHienThi.value = snapshot.isFeatured;
        parentID = snapshot.parentId;
        imageUrl = snapshot.image;
        selectedCategoryName = snapshot.name;
        categoriesName.text = snapshot.name;
      }
    }catch(e){
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không tìm thấy category với ID: $categoryId',
      );
    }
  }

  void setSelectedCategory(CategoryModel category) {
    selectedCategory = category;
  }
}
