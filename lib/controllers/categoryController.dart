import 'package:admin/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  //--- Variables
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  CategoryModel? selectedCategory;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  //--- Functions
  Future<void> fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Categories').get();
      categories.value = snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Lỗi khi tải danh mục: $e');
    }
  }


  void setSelectedCategory(CategoryModel category) {
    selectedCategory = category;
  }

  // Phương thức lấy danh mục đã chọn (nếu cần)
  CategoryModel? getSelectedCategory() {
    return selectedCategory;
  }
}
